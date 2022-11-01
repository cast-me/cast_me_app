// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:async_list_view/async_list_view.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';

class CastListView extends StatefulWidget {
  const CastListView({
    Key? key,
    this.filterProfile,
    this.filterOutProfile,
    this.filterTopics,
    this.padding,
    this.controller,
  }) : super(key: key);

  /// If non-null, fetch only casts authored by the specified user.
  final Profile? filterProfile;

  /// If non-null, exclude casts by the specified user.
  final Profile? filterOutProfile;

  /// If non-null, restrict casts to the given topic.
  final List<Topic>? filterTopics;

  final EdgeInsets? padding;

  final CastListController? controller;

  @override
  State<CastListView> createState() => _CastListViewState();
}

class _CastListViewState extends State<CastListView> {
  // TODO(caseycrogers): this will cause a bug if a controller is added later,
  //   consider adding didUpdateWidget logic.
  late final CastListController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? CastListController();
    controller._attach(this);
  }

  @override
  void dispose() {
    controller._detach(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CastListView oldWidget) {
    if (oldWidget.filterTopics != widget.filterTopics) {
      controller._updateStream();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        controller.refresh();
      },
      // Wrap in an animated builder so that the controller can force the list
      // view to rebuild.
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return AsyncListView<Cast>(
            padding: widget.padding,
            stream: controller._castStream,
            itemBuilder: (
              context,
              snapshot,
              index,
            ) {
              if (!snapshot.hasData) {
                return const AdaptiveText('loading...');
              }
              return CastPreview(
                cast: snapshot.data![index],
              );
            },
            loadingWidget: const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
            noResultsWidgetBuilder: (context) {
              return const Center(
                child: Text(
                  'Could not find any casts',
                  textAlign: TextAlign.center,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CastListController extends ChangeNotifier {
  CastListController();

  late Stream<Cast> _castStream;
  _CastListViewState? _widgetState;

  void refresh() {
    _updateStream();
    _widgetState?.context.dispatchNotification(CastListRefreshNotification());
  }

  void _updateStream() {
    _castStream = _getStream();
    notifyListeners();
  }

  static CastListController? of(BuildContext context) {
    return context.findAncestorStateOfType<_CastListViewState>()?.controller;
  }

  void _attach(_CastListViewState castListView) {
    assert(
      _widgetState == null,
      'can only be attached to one list view at a time',
    );
    _widgetState = castListView;
    _castStream = _getStream();
  }

  void _detach(_CastListViewState castListView) {
    assert(_widgetState == castListView);
    _widgetState = null;
  }

  Stream<Cast> _getStream() {
    assert(_widgetState != null, 'You must attach the controller first.');
    return CastDatabase.instance
        .getCasts(
      filterProfile: _widgetState!.widget.filterProfile,
      filterOutProfile: _widgetState!.widget.filterOutProfile,
      filterTopics: _widgetState!.widget.filterTopics,
    )
        .handleError((Object error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}

class SearchCastListController extends CastListController {
  SearchCastListController() {
    String previousText = searchTextController.text;
    searchTextController.addListener(() {
      if (searchTextController.text == previousText) {
        return;
      }
      previousText = searchTextController.text;
      _castStream = _getStream();
      notifyListeners();
    });
  }

  final TextEditingController searchTextController = TextEditingController();

  @override
  Stream<Cast> _getStream() {
    assert(_widgetState != null, 'You must attach the controller first.');
    return CastDatabase.instance
        .getCasts(
      filterProfile: _widgetState!.widget.filterProfile,
      filterOutProfile: _widgetState!.widget.filterOutProfile,
      searchTerm: searchTextController.text,
    )
        .handleError((Object error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}

class CastListRefreshNotification extends Notification {}

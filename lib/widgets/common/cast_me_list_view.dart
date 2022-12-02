// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:async_list_view/async_list_view.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';
import 'package:cast_me_app/widgets/listen_page/topics_view.dart';

class CastMeListView<T> extends StatefulWidget {
  const CastMeListView({
    Key? key,
    this.controller,
    required this.builder,
    this.padding,
  }) : super(key: key);

  final Widget Function(BuildContext, List<T>, int) builder;

  final EdgeInsets? padding;

  final CastMeListController<T>? controller;

  bool get isCast => T == Cast;

  @override
  State<CastMeListView> createState() => _CastMeListViewState<T>();
}

class _CastMeListViewState<T> extends State<CastMeListView<T>> {
  // TODO(caseycrogers): this will cause a bug if a controller is added later,
  //   consider adding didUpdateWidget logic.
  late CastMeListController<T> controller;
  late Stream<T> stream = controller.getStream();

  void onControllerUpdated() {
    setState(() {
      stream = controller.getStream();
    });
    CastMeListRefreshNotification<T>().dispatch(context);
  }

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? CastMeListController<T>();
    controller.addListener(onControllerUpdated);
  }

  @override
  void dispose() {
    controller.removeListener(onControllerUpdated);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CastMeListView<T> oldWidget) {
    if (oldWidget.controller != widget.controller) {
      controller.removeListener(onControllerUpdated);
      controller = widget.controller ?? CastMeListController<T>();
      controller.addListener(onControllerUpdated);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        onControllerUpdated();
      },
      // Wrap in an animated builder so that the controller can force the list
      // view to rebuild.
      child: AsyncListView<T>(
        padding: widget.padding,
        stream: stream,
        itemBuilder: (
          context,
          snapshot,
          index,
        ) {
          if (!snapshot.hasData) {
            return const Text('loading...');
          }
          return widget.builder(context, snapshot.data!, index);
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
      ),
    );
  }
}

class CastMeListController<T> extends TopicSelectorController {
  CastMeListController({
    super.filterTopics,
    Profile? filterProfile,
    Profile? filterOutProfile,
    this.searchTextController,
    Stream<T> Function(CastMeListController<T>)? getStream,
  })  : _filterProfile = filterProfile,
        _filterOutProfile = filterOutProfile,
        _getStream = getStream {
    searchTextController?.addListener(_onTextChanged);
  }

  /// If non-null, fetch only casts authored by the specified user.
  Profile? _filterProfile;

  Profile? get filterProfile => _filterProfile;

  set filterProfile(Profile? value) {
    _filterProfile = value;
    notifyListeners();
  }

  /// If non-null, exclude casts by the specified user.
  Profile? _filterOutProfile;

  Profile? get filterOutProfile => _filterOutProfile;

  set filterOutProfile(Profile? value) {
    _filterOutProfile = value;
    notifyListeners();
  }

  TextEditingController? searchTextController;

  final Stream<T> Function(CastMeListController<T>)? _getStream;

  String? _previousText;

  Stream<T> getStream() {
    return _internalGetStream().handleError(
      (Object error, StackTrace stackTrace) {
        FlutterError.onError!.call(
          FlutterErrorDetails(exception: error, stack: stackTrace),
        );
      },
    );
  }

  Stream<T> _internalGetStream() {
    if (_getStream != null) {
      return _getStream!(this);
    }
    if (T == Cast) {
      return CastDatabase.instance.getCasts(
        filterProfile: filterProfile,
        filterOutProfile: filterOutProfile,
        filterTopics: filterTopics,
        searchTerm: searchTextController?.text,
      ) as Stream<T>;
    } else if (T == Conversation) {
      return CastDatabase.instance.getConversations(
        filterProfile: filterProfile,
        filterOutProfile: filterOutProfile,
        filterTopics: filterTopics,
        searchTerm: searchTextController?.text,
      ) as Stream<T>;
    }
    throw Exception('Unrecognized type `$T`.');
  }

  void refresh() {
    assertAttached();
    notifyListeners();
  }

  static CastMeListController<T>? of<T>(BuildContext context) {
    return context
        .findAncestorStateOfType<_CastMeListViewState<T>>()
        ?.controller;
  }

  void assertAttached() {
    assert(hasListeners, 'You must attach the controller first.');
  }

  @override
  void dispose() {
    searchTextController?.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (_previousText == null || searchTextController!.text == _previousText) {
      return;
    }
    _previousText = searchTextController!.text;
    notifyListeners();
  }
}

class CastMeListRefreshNotification<T> extends Notification {}

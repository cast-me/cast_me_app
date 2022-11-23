// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:async_list_view/async_list_view.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';

class CastMeListView<T> extends StatefulWidget {
  const CastMeListView({
    Key? key,
    this.controller,
    required this.builder,
    required this.getStream,
    this.padding,
  }) : super(key: key);

  final Stream<T> Function() getStream;

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
  late Stream<T> stream = widget.getStream();

  void onRefresh() {
    setState(() {
      stream = widget.getStream();
    });
    CastMeListRefreshNotification<T>().dispatch(context);
  }

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? CastMeListController<T>();
    controller.addListener(onRefresh);
  }

  @override
  void dispose() {
    controller.removeListener(onRefresh);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CastMeListView<T> oldWidget) {
    if (oldWidget.controller != widget.controller) {
      controller.removeListener(onRefresh);
      controller = widget.controller ?? CastMeListController<T>();
      controller.addListener(onRefresh);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        onRefresh();
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

class CastMeListController<T> extends ChangeNotifier {
  CastMeListController([this.searchTextController]) {
    searchTextController?.addListener(_onTextChanged);
  }

  final TextEditingController? searchTextController;

  String? previousText;

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
    if (previousText == null || searchTextController!.text == previousText) {
      return;
    }
    previousText = searchTextController!.text;
    notifyListeners();
  }
}

class CastMeSearchListController<T> extends CastMeListController<T> {
  CastMeSearchListController() : super(TextEditingController());

  @override
  TextEditingController get searchTextController => super.searchTextController!;
}

class CastMeListRefreshNotification<T> extends Notification {}

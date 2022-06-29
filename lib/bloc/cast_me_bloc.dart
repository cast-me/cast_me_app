import 'package:cast_me_app/bloc/models/cast.dart';
import 'package:cast_me_app/bloc/models/cast_me_tab.dart';
import 'package:cast_me_app/util/listenable_utils.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Contains the top level state for the CastMe App.
///
/// "BLoC" stands for "business logic component". This and other classes named
/// BLoC provide read-only app state to UI elements and expose
/// `on<state_variable>Changed` callbacks to change state in response to user
/// interactions (eg a button press).
///
/// All BLoC classes are singletons with private constructors. They are accessed
/// via `.instance`.
class CastMeBloc {
  CastMeBloc._();

  static final instance = CastMeBloc._();

  final ValueNotifier<CastMeTab> _currentTab = ValueNotifier(CastMeTab.listen);

  ValueListenable<CastMeTab> get currentTab => _currentTab;

  void onTabChanged(CastMeTab newTab) {
    _currentTab.value = newTab;
  }

  final ListenBloc listenModel = ListenBloc._();
}

/// Contains the state for the `ListenPage`.
class ListenBloc {
  ListenBloc._();

  static final instance = CastMeBloc.instance.listenModel;

  final ValueNotifier<Cast?> _currentCast = ValueNotifier(null);

  final ValueListenablePageController listenPageController =
      ValueListenablePageController();

  ValueListenable<Cast?> get currentCast => _currentCast;

  ValueListenable<double> get currentListenPage => listenPageController;

  void onCastChanged(Cast newCast) {
    _currentCast.value = newCast;
  }

  void onListenPageChanged(ListenPage newPage) {
    listenPageController.animateToPage(
      ListenPage.values.indexOf(newPage),
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }
}

enum ListenPage {
  following,
  trending,
}

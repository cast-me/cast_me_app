import 'package:cast_me_app/models/cast.dart';
import 'package:cast_me_app/models/cast_me_tab.dart';
import 'package:cast_me_app/util/listenable_utils.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CastMeModel {
  CastMeModel._();

  static final instance = CastMeModel._();

  final ValueNotifier<CastMeTab> _currentTab = ValueNotifier(CastMeTab.listen);

  ValueListenable<CastMeTab> get currentTab => _currentTab;

  void onTabChanged(CastMeTab newTab) {
    _currentTab.value = newTab;
  }

  final ListenModel listenModel = ListenModel._();
}

class ListenModel {
  ListenModel._();

  static final instance = CastMeModel.instance.listenModel;

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

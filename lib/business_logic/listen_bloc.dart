import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/util/listenable_utils.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Contains the state for the `ListenPage`.
class ListenBloc {
  ListenBloc._();

  static final instance = ListenBloc._();

  final ValueNotifier<Cast?> _currentCast = ValueNotifier(null);

  final ValueNotifier<bool> _nowPlayingIsExpanded = ValueNotifier(false);

  final ValueListenablePageController listenPageController =
      ValueListenablePageController();

  final CastAudioPlayer player = CastAudioPlayer.instance;

  ValueListenable<Cast?> get currentCast => _currentCast;

  ValueListenable<double> get currentListenPage => listenPageController;

  ValueListenable<bool> get nowPlayingIsExpanded => _nowPlayingIsExpanded;

  void onCastChanged(Cast newCast) {
    _currentCast.value = newCast;
    player.play(newCast);
  }

  void onListenPageChanged(ListenPage newPage) {
    listenPageController.animateToPage(
      ListenPage.values.indexOf(newPage),
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void onNowPlayingExpansionToggled() {
    _nowPlayingIsExpanded.value = !_nowPlayingIsExpanded.value;
  }
}

enum ListenPage {
  following,
  trending,
}

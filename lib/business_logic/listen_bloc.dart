import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/util/listenable_utils.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Contains the state for the `ListenPage`.
class ListenBloc {
  ListenBloc._();

  static final instance = ListenBloc._();

  ValueListenable<Cast?> get currentCast =>
      CastAudioPlayer.instance.currentCast;

  final ValueNotifier<bool> _nowPlayingIsExpanded = ValueNotifier(false);

  ValueListenable<bool> get nowPlayingIsExpanded => _nowPlayingIsExpanded;

  final ValueNotifier<bool> _trackListIsDisplayed = ValueNotifier(false);

  ValueListenable<bool> get trackListIsDisplayed => _trackListIsDisplayed;

  final ValueListenablePageController listenPageController =
      ValueListenablePageController();

  ValueListenable<double> get currentListenPage => listenPageController;

  void onCastSelected(Cast newCast, {bool autoPlay = true}) {
    CastAudioPlayer.instance.load(newCast, autoPlay: autoPlay);
  }

  void onCastInTrackListSelected(Cast newCast) {
    CastAudioPlayer.instance.seekToCast(newCast);
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
    // Collapse the track list on close.
    _trackListIsDisplayed.value = false;
  }

  void onDisplayTrackListToggled() {
    _trackListIsDisplayed.value = !_trackListIsDisplayed.value;
  }
}

enum ListenPage {
  following,
  trending,
}

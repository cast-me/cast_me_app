import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
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

  final ValueNotifier<bool> _trackListIsDisplayed = ValueNotifier(false);

  ValueListenable<bool> get trackListIsDisplayed => _trackListIsDisplayed;

  final ValueListenablePageController listenPageController =
      ValueListenablePageController();

  ValueListenable<double> get currentListenPage => listenPageController;


  Future<void> onCastIdSelected(String castId, {bool autoPlay = true}) async {
    final Cast newCast = await CastDatabase.instance.getCast(castId: castId);
    await CastAudioPlayer.instance.load(newCast, autoPlay: autoPlay);
  }

  void onCastSelected(Cast cast, {bool autoPlay = true}) {
    CastAudioPlayer.instance.load(cast, autoPlay: autoPlay);
  }

  void onCastInTrackListSelected(Cast cast) {
    CastAudioPlayer.instance.seekToCast(cast);
  }

  void onListenPageChanged(ListenPage newPage) {
    listenPageController.animateToPage(
      ListenPage.values.indexOf(newPage),
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void onDisplayTrackListToggled() {
    _trackListIsDisplayed.value = !_trackListIsDisplayed.value;
  }
}

enum ListenPage {
  following,
  trending,
}

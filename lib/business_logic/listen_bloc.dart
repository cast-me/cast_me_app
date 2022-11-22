// Flutter imports:
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/util/listenable_utils.dart';

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

  final CastMeListController<Cast> castListController = CastMeListController();

  ValueListenable<double> get currentListenPage => listenPageController;

  final ValueNotifier<List<Topic>> _filteredTopics = ValueNotifier([]);

  ValueListenable<List<Topic>> get filteredTopics => _filteredTopics;

  Future<void> onCastIdSelected({
    required String castId,
    bool autoplay = true,
  }) async {
    final Cast newCast = await CastDatabase.instance.getCast(castId: castId);
    await onCastSelected(newCast, autoPlay: autoplay);
  }

  Future<void> onTruncatedCastIdSelected({
    required String authorUsername,
    required String truncId,
    bool autoPlay = true,
  }) async {
    // Truncated cast ids are used in share links. They're only 8 characters
    // long to make them more user friendly.
    assert(
      truncId.length == 8,
      'Truncated castId had an invalid length of ${truncId.length}.',
    );
    final Cast newCast = await CastDatabase.instance.getCastFromTruncatedId(
      authorUsername: authorUsername,
      truncId: truncId,
    );
    await CastAudioPlayer.instance.load(
      newCast,
      filterTopics: [],
      autoPlay: autoPlay,
    );
  }

  Future<void> onCastSelected(Cast cast, {bool autoPlay = true}) async {
    await CastAudioPlayer.instance.load(
      cast,
      filterTopics: filteredTopics.value,
      autoPlay: autoPlay,
    );
  }

  Future<void> onCastInTrackListSelected(Cast cast) async {
    await CastAudioPlayer.instance.seekToCast(cast);
  }

  Future<void> onListenPageChanged(ListenPage newPage) async {
    await listenPageController.animateToPage(
      ListenPage.values.indexOf(newPage),
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void onDisplayTrackListToggled() {
    _trackListIsDisplayed.value = !_trackListIsDisplayed.value;
  }

  void onTopicToggled(Topic topic) {
    _filteredTopics.toggle(topic, byKey: (t) => t.id);
    castListController.refresh();
  }
}

enum ListenPage {
  following,
  trending,
}

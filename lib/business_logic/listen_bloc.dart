// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';

/// Contains the state for the `ListenPage`.
class ListenBloc {
  ListenBloc._();

  static ListenBloc instance = ListenBloc._();

  ValueListenable<Cast?> get currentCast =>
      CastAudioPlayer.instance.currentCast;

  final ValueNotifier<bool> _trackListIsDisplayed = ValueNotifier(false);

  ValueListenable<bool> get trackListIsDisplayed => _trackListIsDisplayed;

  final ValueListenablePageController listenPageController =
      ValueListenablePageController();

  final CastMeListController<Conversation> timelineListController =
      CastMeListController(where: (c) => c.isNotEmpty);

  ValueListenable<double> get currentListenPage => listenPageController;

  ValueListenable<List<Topic>> get timelineFilteredTopics =>
      timelineListController.select((t) => t.filterTopics);

  final ValueNotifier<SelectedConversation?> _selectedConversation =
      ValueNotifier(null);

  ValueListenable<SelectedConversation?> get selectedConversation =>
      _selectedConversation;

  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  Future<void> onCastIdSelected({
    required String castId,
    bool autoplay = true,
  }) async {
    final Cast newCast = await CastDatabase.instance.getCast(castId: castId);
    await onCastSelected(newCast, startPlaying: autoplay);
  }

  Future<void> onTruncatedCastIdSelected({
    required String authorUsername,
    required String truncId,
    bool startPlaying = true,
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
      startPlaying: startPlaying,
    );
  }

  Future<void> onCastSelected(Cast cast, {bool startPlaying = true}) async {
    await CastAudioPlayer.instance.load(
      cast,
      filterTopics: timelineFilteredTopics.value,
      startPlaying: startPlaying,
    );
  }

  Future<void> onPlayAll({
    required Cast seedCast,
    bool startPlaying = true,
  }) async {
    await CastAudioPlayer.instance
        .load(seedCast, filterTopics: [], startPlaying: startPlaying);
  }

  Future<void> onForYouSelected(Topic forYou, {bool startPlaying = true}) async {
    final Cast cast = await CastDatabase.instance.getCasts(
      filterTopics: [forYou],
      filterOutProfile: AuthManager.instance.profile,
      skipViewed: true,
      single: true,
    ).single;
    await CastAudioPlayer.instance.load(
      cast,
      filterTopics: [forYou],
      startPlaying: startPlaying,
    );
  }

  void onConversationIdSelected(
    String? id, {
    Future<Conversation>? conversation,
  }) {
    if (id == _selectedConversation.value?.id) {
      return;
    }
    if (id == null) {
      _selectedConversation.value = null;
      return;
    }
    _selectedConversation.value = SelectedConversation(
      id,
      conversation: conversation,
    );
  }

  void onConversationSelected(Conversation? conversation) {
    onConversationIdSelected(
      conversation?.rootId,
      conversation: conversation == null ? null : Future.value(conversation),
    );
  }

  Future<void> playConversation(
    Conversation conversation, {
    bool skipViewed = true,
    Cast? startAtCast,
  }) async {
    final List<Cast> castsToPlay =
        (skipViewed ? conversation.newCasts : conversation.allCasts)
            .where((c) => !c.deleted)
            .toList();
    final int startAtIndex =
        startAtCast == null ? 0 : castsToPlay.indexOf(startAtCast);
    await CastAudioPlayer.instance.load(
      castsToPlay.first,
      // Provide empty list, not relevant.
      filterTopics: [],
      playQueue: castsToPlay.sublist(1),
      startAt: startAtIndex,
    );
  }

  Future<void> onCastInTrackListSelected(Cast cast) async {
    await CastAudioPlayer.instance.seekToCast(cast);
  }

  Future<void> onListenPageChanged(int pageIndex) async {
    await listenPageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  void onDisplayTrackListToggled() {
    _trackListIsDisplayed.value = !_trackListIsDisplayed.value;
  }

  void closeBottomSheet() {
    sheetController.animateTo(
      0,
      duration: const Duration(milliseconds: 50),
      curve: Curves.linear,
    );
  }

  @visibleForTesting
  static void reset() {
    ListenBloc.instance = ListenBloc._();
  }
}

class SelectedConversation {
  SelectedConversation(
    this.id, {
    Future<Conversation>? conversation,
  }) : _conversation = ValueNotifier(conversation ?? _getConversation(id));

  SelectedConversation.fromConversation(Conversation syncConversation)
      : id = syncConversation.rootId,
        _conversation = ValueNotifier(Future.value(syncConversation));

  final String id;

  ValueListenable<Future<Conversation>> get conversation => _conversation;

  final ValueNotifier<Future<Conversation>> _conversation;

  Future<void> refresh() async {
    _conversation.value = _getConversation(id);
    await _conversation.value;
  }

  static Future<Conversation> _getConversation(String id) {
    return CastDatabase.instance.getConversation(id);
  }
}

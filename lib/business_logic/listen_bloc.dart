// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Project imports:
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

  static final instance = ListenBloc._();

  ValueListenable<Cast?> get currentCast =>
      CastAudioPlayer.instance.currentCast;

  final ValueNotifier<bool> _trackListIsDisplayed = ValueNotifier(false);

  ValueListenable<bool> get trackListIsDisplayed => _trackListIsDisplayed;

  final ValueListenablePageController listenPageController =
      ValueListenablePageController();

  final CastMeListController<Conversation> timelineListController =
      CastMeListController(where: (c) => c.isNotEmpty);

  ValueListenable<double> get currentListenPage => listenPageController;

  ValueListenable<List<Topic>> get filteredTopics =>
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
    await CastAudioPlayer.instance.load(castsToPlay[0],
        // Provide empty list, not relevant.
        filterTopics: [],
        playQueue: castsToPlay.sublist(1),
        startAt: startAtIndex);
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

  void closeBottomSheet() {
    sheetController.animateTo(
      0,
      duration: const Duration(milliseconds: 50),
      curve: Curves.linear,
    );
  }
}

enum ListenPage {
  following,
  trending,
}

class SelectedConversation {
  SelectedConversation(
    this.id, {
    Future<Conversation>? conversation,
  }) : conversation = conversation ?? CastDatabase.instance.getConversation(id);

  SelectedConversation.fromConversation(Conversation syncConversation)
      : id = syncConversation.rootId,
        conversation = Future.value(syncConversation);

  final String id;
  final Future<Conversation> conversation;
}

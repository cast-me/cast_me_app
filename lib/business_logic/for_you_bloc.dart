// Flutter imports:
import 'package:cast_me_app/business_logic/clients/bulletin_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/bulletin_message.dart';
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:collection/collection.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';

class ForYouBloc {
  ForYouBloc._() {
    BulletinDatabase.instance.getMessage().then((m) {
      _message.value = m;
    });
  }

  static ForYouBloc instance = ForYouBloc._();

  final ValueNotifier<Future<Cast?>> _seedCast = ValueNotifier(_getSeedCast());

  final ValueNotifier<Future<List<Conversation>>>
      _continueListeningConversations =
      ValueNotifier(_getContinueListeningConversations());

  final ValueNotifier<Future<List<Conversation>>> _curatedConversations =
      ValueNotifier(_getCuratedConversations());

  // Make this late so that we don't issue a DB request at launch.
  late final ValueNotifier<Future<List<Cast>>> _followUpCasts =
      ValueNotifier(_getFollowUpCasts());

  ValueListenable<Future<Cast?>> get seedCast => _seedCast;

  ValueListenable<Future<List<Conversation>>>
      get continueListeningConversations => _continueListeningConversations;

  ValueListenable<Future<List<Conversation>>> get curatedConversations =>
      _curatedConversations;

  ValueListenable<Future<List<Cast>>> get followUpCasts => _followUpCasts;

  static final ValueNotifier<BulletinMessage?> _message = ValueNotifier(null);

  ValueListenable<BulletinMessage?> get bulletinMessage => _message;

  Future<void> onRefresh() async {
    _seedCast.value = _getSeedCast();
    _continueListeningConversations.value =
        _getContinueListeningConversations();
    _curatedConversations.value = _getCuratedConversations();
    _followUpCasts.value = _getFollowUpCasts();
    await Future.wait(
      [
        _seedCast.value,
        _continueListeningConversations.value,
        _followUpCasts.value,
      ],
    );
  }

  static Future<Cast?> _getSeedCast() {
    return CastDatabase.instance
        .getCasts(
          filterOutProfile: AuthManager.instance.profile,
          skipViewed: true,
          single: true,
        )
        .toList()
        .then((casts) {
      if (casts.isEmpty) {
        return null;
      }
      return casts.single;
    });
  }

  static Future<List<Conversation>> _getCuratedConversations() async {
    return (await CastDatabase.instance
            .getCuratedConversations(
              limit: 10,
            )
            .toList())
        .sortedBy<num>((c) => c.hasNewCasts ? 0 : 1);
  }

  static Future<List<Conversation>> _getContinueListeningConversations() {
    return CastDatabase.instance
        .getConversations(
          limit: 10,
          onlyUpdates: true,
        )
        .toList();
  }

  static Future<List<Cast>> _getFollowUpCasts() {
    return CastDatabase.instance
        .getCasts(
          limit: 10,
          onlyViewed: true,
        )
        .toList();
  }
}

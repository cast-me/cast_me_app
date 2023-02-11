// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';

class ForYouBloc {
  ForYouBloc._();

  static ForYouBloc instance = ForYouBloc._();

  final ValueNotifier<Future<Cast?>> _seedCast =
      ValueNotifier(_getSeedCast());

  final ValueNotifier<Future<List<Conversation>>>
      _continueListeningConversations =
      ValueNotifier(_getContinueListeningConversations());

  // Make this late so that we don't issue a DB request at launch.
  late final ValueNotifier<Future<List<Cast>>> _followUpCasts =
      ValueNotifier(_getFollowUpCasts());

  ValueListenable<Future<Cast?>> get seedCast => _seedCast;

  ValueListenable<Future<List<Conversation>>>
      get continueListeningConversations => _continueListeningConversations;

  ValueListenable<Future<List<Cast>>> get followUpCasts => _followUpCasts;

  Future<void> onRefresh() async {
    _seedCast.value = _getSeedCast();
    _continueListeningConversations.value =
        _getContinueListeningConversations();
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
    return CastDatabase.instance.getCasts(
      filterOutProfile: AuthManager.instance.profile,
      skipViewed: true,
      single: true,
    ).toList().then((casts) {
      if (casts.isEmpty) {
        return null;
      }
      return casts.single;
    });
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

import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:flutter/foundation.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';

class ForYouBloc {
  ForYouBloc._();

  static ForYouBloc instance = ForYouBloc._();

  final ValueNotifier<Future<List<Topic>>> _trending =
      ValueNotifier(_getTrendingTopics());

  final ValueNotifier<Future<List<Conversation>>>
      _continueListeningConversations =
      ValueNotifier(_getContinueListeningConversations());

  final ValueNotifier<Future<List<Cast>>> _followUpCasts =
      ValueNotifier(_getFollowUpCasts());

  ValueListenable<Future<List<Topic>>> get trending => _trending;

  ValueListenable<Future<List<Conversation>>>
      get continueListeningConversations => _continueListeningConversations;

  ValueListenable<Future<List<Cast>>> get followUpCasts => _followUpCasts;

  Future<void> onRefresh() async {
    _trending.value = _getTrendingTopics();
    _continueListeningConversations.value =
        _getContinueListeningConversations();
    _followUpCasts.value = _getFollowUpCasts();
    await Future.wait(
      [
        _trending.value,
        _continueListeningConversations.value,
        _followUpCasts.value,
      ],
    );
  }

  static Future<List<Topic>> _getTrendingTopics() {
    return CastDatabase.instance.getTopics(limit: 3);
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

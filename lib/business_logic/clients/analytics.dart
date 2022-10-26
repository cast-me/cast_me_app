import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Analytics {
  Analytics._();

  static final instance = Analytics._();

  String? _setId;

  String? get userId => _setId;

  Future<void> setUserId(String? userId) async {
    if (_setId == userId) {
      // Don't bother setting if there's nothing to change.
      return;
    }
    await FirebaseAnalytics.instance.setUserId(id: userId);
    _setId = userId;
  }

  // AUTH
  // TODO(caseycrgers): some of these are logged after the auth action is
  //  complete which is inconsistent with all other logging. Consider flipping.
  void logSignUp({
    required String email,
  }) {
    FirebaseAnalytics.instance.logSignUp(signUpMethod: 'email');
  }

  void logLogin({
    required String loginMethod,
  }) {
    FirebaseAnalytics.instance.logLogin(loginMethod: loginMethod);
  }

  void logCompleteProfile() {
    FirebaseAnalytics.instance.logEvent(
      name: 'completeProfile',
    );
  }

  void logLogout() {
    FirebaseAnalytics.instance.logEvent(
      name: 'signOut',
    );
  }

  void logSetNewPassword() {
    FirebaseAnalytics.instance.logEvent(
      name: 'resetPasswordEmail',
    );
  }

  void logSendResetPasswordEmail({
    required String email,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'resetPasswordEmail',
      parameters: {
        'email': email,
      },
    );
  }

  // GENERAL UI
  void logTabSelect({
    required CastMeTab fromTab,
    required CastMeTab toTab,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'tabSelect',
      parameters: {
        'fromTab': fromTab.prettyName,
        'toTab': toTab.prettyName,
      },
    );
  }

  // CAST publishing
  void logCreate({required String castId}) {
    FirebaseAnalytics.instance.logEvent(
      name: 'create',
      parameters: {
        'cast_id': castId,
      },
    );
  }

  void logDelete({required Cast cast}) {
    FirebaseAnalytics.instance.logEvent(
      name: 'delete',
      parameters: {
        'cast_id': cast.id,
      },
    );
  }

  // CAST PLAYBACK
  void logListen({required Cast cast}) {
    FirebaseAnalytics.instance.logEvent(
      name: 'listen',
      parameters: {
        'cast_id': cast.id,
      },
    );
  }

  void logSkip({
    required Cast cast,
    required Duration skippedAt,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'skip',
      parameters: {
        'cast_id': cast.id,
        'skipped_at_ms': skippedAt.inMilliseconds,
      },
    );
  }

  void logSeek({
    required Cast targetCast,
    required Cast? skippedCast,
    required Duration? skippedAt,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'seek',
      parameters: {
        'cast_id': targetCast.id,
        'skipped_cast_id': skippedCast,
        'skipped_at_ms': skippedAt?.inMilliseconds,
      },
    );
  }

  void logPlay({required Cast cast}) {
    FirebaseAnalytics.instance.logEvent(
      name: 'play',
      parameters: {
        'cast_id': cast.id,
      },
    );
  }

  void logPause({
    required Cast? cast,
    required Duration pausedAt,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'pause',
      parameters: {
        if (cast != null) 'cast_id': cast.id,
        'paused_at_ms': pausedAt.inMilliseconds,
      },
    );
  }

  void logUnpause({
    required Cast cast,
    required Duration unPausedAt,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'unpause',
      parameters: {
        'cast_id': cast.id,
        'unpaused_at_ms': unPausedAt.inMilliseconds,
      },
    );
  }

  void logSeekTo({
    required Cast cast,
    required Duration seekedAt,
    required Duration seekedTo,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'seekTo',
      parameters: {
        'cast_id': cast.id,
        'seeked_at_ms': seekedAt.inMilliseconds,
        'seeked_to_ms': seekedTo.inMilliseconds,
      },
    );
  }

  void logSetSpeed({
    required Cast? cast,
    required double fromSpeed,
    required double toSpeed,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'setSpeed',
      parameters: {
        if (cast != null) 'cast_id': cast.id,
        'from_speed': fromSpeed,
        'to_speed': toSpeed,
      },
    );
  }

  void logLiked({
    required Cast cast,
    required bool liked,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'like',
      parameters: {
        'cast_id': cast.id,
        'liked': liked.toString(),
      },
    );
  }
}

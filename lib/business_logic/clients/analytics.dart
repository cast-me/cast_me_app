import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  Analytics._();

  static final Analytics instance = Analytics._();


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
      }
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
        'cast_id': cast?.id,
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
        'cast_id': cast?.id,
        'from_speed': fromSpeed,
        'to_speed': toSpeed,
      },
    );
  }
}

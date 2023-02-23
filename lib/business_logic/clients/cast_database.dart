// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:ffmpeg_kit_flutter_audio/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/media_information.dart';
import 'package:ffmpeg_kit_flutter_audio/media_information_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/analytics.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/util/object_utils.dart';
import 'package:cast_me_app/util/string_utils.dart';

class CastDatabase {
  CastDatabase._();

  static final CastDatabase instance = CastDatabase._();

  Stream<Conversation> getCuratedConversations({
    // Only fetch conversations that have updates since last listen.
    bool onlyUpdates = false,
    int? limit,
  }) async* {
    final PostgrestFilterBuilder<Rows> filtered = _filterQuery(
      curatedConversationsReadQuery,
      skipViewed: false,
    );
    if (onlyUpdates) {
      // If the conversation isn't all new but there's at least one new cast,
      // then there's at least one update.
      unawaited(filtered.eq(allNewCol, false).gt(newCastCountCol, 0));
    }
    final PostgrestTransformBuilder ordered = _orderQuery(filtered);
    yield* paginated(
      ordered,
      chunkSize: 10,
      chunkLimit: limit != null ? limit ~/ 10 : null,
    ).map(_rowToConversation);
  }

  Stream<Conversation> getConversations({
    Profile? filterProfile,
    Profile? filterOutProfile,
    List<Topic>? filterTopics,
    // Only fetch conversations that have updates since last listen.
    bool onlyUpdates = false,
    int? limit,
  }) async* {
    final PostgrestFilterBuilder<Rows> filtered = _filterQuery(
      conversationsReadQuery,
      filterProfile: filterProfile,
      filterOutProfile: filterOutProfile,
      filterTopics: filterTopics,
      skipViewed: false,
    );
    if (onlyUpdates) {
      // If the conversation isn't all new but there's at least one new cast,
      // then there's at least one update.
      unawaited(filtered.eq(allNewCol, false).gt(newCastCountCol, 0));
    }
    final PostgrestTransformBuilder ordered = _orderQuery(filtered);
    yield* paginated(
      ordered,
      chunkSize: 10,
      chunkLimit: limit != null ? limit ~/ 10 : null,
    ).map(_rowToConversation);
  }

  // TODO(caseycrogers): replace a bunch of these bools with enums.
  Stream<Cast> getCasts({
    Cast? seedCast,
    Profile? filterProfile,
    Profile? filterOutProfile,
    List<Topic>? filterTopics,
    bool skipViewed = false,
    bool onlyViewed = false,
    String? searchTerm,
    bool single = false,
    bool skipDeleted = true,
    int? limit,
  }) async* {
    // This is here because we need two instances of the builder at the end to
    // run two separate queries because Supabase doesn't provide a copy method.
    // TODO: remove this function and use copy once it's available.
    PostgrestFilterBuilder<Rows> getBuilder() {
      return _filterQuery(
        castsReadQuery,
        seedCast: seedCast,
        filterProfile: filterProfile,
        filterOutProfile: filterOutProfile,
        filterTopics: filterTopics,
        skipViewed: skipViewed,
        onlyViewed: onlyViewed,
        searchTerm: searchTerm,
        single: single,
        skipDeleted: skipDeleted,
      );
    }

    Stream<Cast> paginateCasts(PostgrestFilterBuilder<Rows> query) {
      return paginated(
        _orderQuery(query),
        chunkSize: single ? 1 : 10,
        chunkLimit: single ? 1 : limit?.apply((l) => l ~/ 10),
      ).map(_rowToCast);
    }

    if (seedCast != null) {
      // Yield all the casts from the seed cast's conversation first, then play
      // casts from outside the conversation.
      // This is to ensure that, when a user selects a cast, the whole
      // conversation is played through before casts form other conversations.
      yield* paginateCasts(
        getBuilder().neq(idCol, seedCast.id).eq(rootIdCol, seedCast.rootId),
      );
      yield* paginateCasts(
        getBuilder().neq(idCol, seedCast.id).neq(rootIdCol, seedCast.rootId),
      );
    } else {
      yield* paginateCasts(getBuilder());
    }
  }

  // Applies filters shared between casts and conversations.
  PostgrestFilterBuilder<Rows> _filterQuery(
    SupabaseQueryBuilder tableQuery, {
    Cast? seedCast,
    Profile? filterProfile,
    Profile? filterOutProfile,
    List<Topic>? filterTopics,
    bool skipViewed = false,
    bool onlyViewed = false,
    String? searchTerm,
    bool single = false,
    bool skipDeleted = true,
  }) {
    PostgrestFilterBuilder<Rows> queryBuilder = tableQuery.select<Rows>();
    // Always filter by cast privacy.
    // TODO(caseycrogers): Move this server side?
    queryBuilder = queryBuilder.or('$isPrivateCol.eq.false,'
        '$authorIdCol.eq.${AuthManager.instance.user!.id},'
        '$visibleToCol.cs.{"${AuthManager.instance.user!.id}"}');
    if (filterProfile != null) {
      // Get only casts authored by the given profiles.
      queryBuilder = queryBuilder.eq(authorIdCol, filterProfile.id);
    }
    if (filterOutProfile != null) {
      queryBuilder = queryBuilder.neq(authorIdCol, filterOutProfile.id);
    }
    if (skipViewed) {
      queryBuilder = queryBuilder.eq(hasViewedCol, false);
    }
    if (onlyViewed) {
      queryBuilder = queryBuilder.eq(hasViewedCol, true);
    }
    if (skipDeleted) {
      queryBuilder = queryBuilder.eq(deletedCol, false);
    }
    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryBuilder = queryBuilder.or('$titleCol.ilike.%$searchTerm%,'
          '$authorUsernameCol.ilike.$searchTerm%,'
          '$authorDisplayNameCol.ilike.$searchTerm%');
    }
    if (filterTopics != null && filterTopics.isNotEmpty) {
      queryBuilder = queryBuilder.overlaps(
        topicsCol,
        filterTopics.map((t) => t.name).toList(),
      );
    }
    return queryBuilder;
  }

  // Apply ordering shared between Casts and Conversations.
  PostgrestTransformBuilder<Rows> _orderQuery(
      PostgrestFilterBuilder<Rows> query) {
    return query
        // Play the freshest conversations first.
        // We're using promoted date which is the time the tree was last updated
        // plus any manual or algorithmic boosts to it's "freshness".
        .order(promotedDateCol, ascending: false)
        // Within a specific depth level, play the oldest content first as new
        // content in a level might build on other content in that level.
        .order(createdAtCol, ascending: true);
  }

  Future<Cast> getCast({required String castId}) async {
    return castsReadQuery
        .select<Map<String, dynamic>>()
        .eq(idCol, castId)
        .single()
        .withConverter(_rowToCast);
  }

  Future<Conversation> getConversation(String rootId) async {
    return conversationsReadQuery
        .select<Map<String, dynamic>>()
        .eq(rootIdCol, rootId)
        .single()
        .withConverter(_rowToConversation);
  }

  /// Get a cast given an author and the first 8 characters of a cast id.
  ///
  /// Truncated cast ids are used in share links to make the links shorter.
  Future<Cast> getCastFromTruncatedId({
    required String authorUsername,
    required String truncId,
  }) async {
    return castsReadQuery
        .select<Map<String, dynamic>>()
        .eq(authorUsernameCol, authorUsername)
        // UUIDs are technically binary blobs not strings so we can't use like.
        .gt('id', '$truncId-0000-0000-0000-000000000000')
        .lt('id', '$truncId-ffff-ffff-ffff-ffffffffffff')
        .single()
        .withConverter(_rowToCast);
  }

  Future<Cast?> getSeedCast() {
    return getCasts(
      skipViewed: true,
      filterOutProfile: AuthManager.instance.profile,
      single: true,
    ).toList().then((value) {
      return value.isEmpty ? null : value.single;
    });
  }

  Stream<Cast> getPlayQueue(
      {required Cast seedCast, required List<Topic> filterTopics}) {
    return getCasts(
      seedCast: seedCast,
      skipViewed: true,
      filterOutProfile: AuthManager.instance.profile,
      filterTopics: filterTopics,
    );
  }

  // Returns the id of the cast.
  Future<String> createCast({
    required String title,
    required String url,
    required CastFile castFile,
    required Cast? replyTo,
    required List<Topic> topics,
  }) async {
    // TODO(caseycrogers): consider moving this to a server function.
    final String fileExt = castFile.name.split('.').last;
    // Hash the file name so we don't get naming conflicts. Since we're using a
    // hash, redundant uploads won't increase storage usage. We're prefixing
    // with the username so that when a user deletes a cast we can safely delete
    // the storage object-we're preventing another user from uploading the same
    // file under the exact same name.
    final String fileName = '${AuthManager.instance.profile.username}'
        '_${await _getHash(castFile.file)}.$fileExt';

    await castAudioFileBucket.upload(
      fileName,
      castFile.file,
      fileOptions: const FileOptions(upsert: true),
    );
    final String audioFileUrl = castAudioFileBucket.getPublicUrl(fileName);
    final WriteCast cast = WriteCast(
      authorId: supabase.auth.currentUser!.id,
      title: title,
      durationMs: castFile.duration.inMilliseconds,
      audioUrl: audioFileUrl,
      replyTo: replyTo?.id,
      externalUrl: url.emptyToNull,
    );
    final String castId = _rowToId(
      await castsWriteQuery
          .insert(_writeCastToRow(cast))
          .select<Map<String, dynamic>>(idCol)
          .single(),
    );
    await castsToTopicWriteQuery.insert(topics.map((t) {
      return <String, dynamic>{
        'topic_id': t.id,
        'cast_id': castId,
      };
    }).toList());
    // Override the local id with the server set value
    // TODO(caseycrogers): this will only log if the create succeeds, consider
    //   wrapping in a finally or something.
    Analytics.instance.logCreate(castId: castId);
    return castId;
  }

  Future<void> deleteCast({
    required Cast cast,
  }) async {
    Analytics.instance.logDelete(cast: cast);
    await castsWriteQuery.update(
      <String, dynamic>{deletedCol: true},
    ).eq(idCol, cast.id);
  }

  Future<void> setListened({required Cast cast}) async {
    Analytics.instance.logListen(cast: cast);
    await listensQuery.insert({
      castIdCol: cast.id,
      userIdCol: supabase.auth.currentUser!.id,
    });
  }

  Future<void> setSkipped({
    required Cast cast,
    required SkippedReason skippedReason,
    required Duration skippedAt,
  }) async {
    Analytics.instance.logSkip(cast: cast, skippedAt: skippedAt);
    await listensQuery.insert({
      castIdCol: cast.id,
      userIdCol: supabase.auth.currentUser!.id,
      'skipped_reason': skippedReason.toString().split('.').last,
    });
  }

  Future<void> setLiked({
    required Cast cast,
    required bool liked,
  }) async {
    Analytics.instance.logLiked(cast: cast, liked: liked);
    final String userId = AuthManager.instance.profile.id;
    if (!liked) {
      await likesQuery.delete().eq(userIdCol, userId).eq(castIdCol, cast.id);
      return;
    }
    await likesQuery.insert({
      userIdCol: userId,
      castIdCol: cast.id,
    });
  }

  Future<List<Topic>> getTopics({int? limit}) async {
    PostgrestTransformBuilder<List<Map<String, dynamic>>> query =
        topicsReadQuery
            .select<List<Map<String, dynamic>>>()
            .order('cast_count');
    if (limit != null) {
      query = query.limit(limit);
    }
    return await query.withConverter((data) {
      return data.map(_rowToTopic).toList();
    });
  }
}

enum SkippedReason {
  nextButton,
  seekButton,
}

String _rowToId(dynamic row) {
  return (row as Map<String, dynamic>)[idCol]! as String;
}

Cast _rowToCast(Map<String, dynamic> row) {
  return Cast.fromJson(row);
}

Topic _rowToTopic(Map<String, dynamic> row) {
  return Topic.fromJson(row);
}

Conversation _rowToConversation(Map<String, dynamic> row) {
  return Conversation.fromJson(row);
}

Map<String, dynamic> _writeCastToRow(WriteCast cast) {
  return cast.toJson();
}

Future<int> getFileDuration(String mediaPath) async {
  final MediaInformationSession mediaInfoSession =
      await FFprobeKit.getMediaInformation(mediaPath);
  final MediaInformation? mediaInfo = mediaInfoSession.getMediaInformation();

  // the given duration is in fractional seconds, convert to ms
  final int durationMs =
      (double.parse(mediaInfo!.getDuration()!) * 1000).round();
  return durationMs;
}

Future<String> _getHash(File file) async {
  return (await file.openRead().transform(sha256).first).hashCode.toString();
}

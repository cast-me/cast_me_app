// Dart imports:
import 'dart:io';
import 'dart:math';

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
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:cast_me_app/util/string_utils.dart';

class CastDatabase {
  CastDatabase._();

  static final CastDatabase instance = CastDatabase._();

  Stream<Cast> getCasts({
    Cast? seedCast,
    Profile? filterProfile,
    Profile? filterOutProfile,
    List<Topic>? filterTopics,
    bool skipViewed = false,
    String? searchTerm,
    bool single = false,
  }) async* {
    // This is here because we need two instances of the builder at the end to
    // run two separate queries because Supabase doesn't provide a copy method.
    // TODO: remove this function and use copy once it's available.
    PostgrestFilterBuilder getBuilder() {
      PostgrestFilterBuilder queryBuilder = castsReadQuery.select();
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
      if (searchTerm != null && searchTerm.isNotEmpty) {
        queryBuilder = queryBuilder.or('$titleCol.ilike.%$searchTerm%,'
            '$authorUsernameCol.ilike.$searchTerm%,'
            '$authorDisplayNameCol.ilike.$searchTerm%');
      }
      if (filterTopics != null) {
        queryBuilder = queryBuilder.overlaps(
          topicsCol,
          filterTopics.map((t) => t.name).toList(),
        );
      }
      return queryBuilder;
    }

    Stream<Cast> orderAndRun(PostgrestFilterBuilder query) {
      final PostgrestTransformBuilder transformBuilder = query
          // Put conversations and individual casts that don't have any new
          // content at the bottom.
          .order(treeHasNewCastsCol, ascending: false)
          // Play the freshest conversations first.
          .order(treeUpdatedAtCol, ascending: false)
          // Play parent content before replies. Not sure this is desirable,
          // This is equivalent to BFS. Removing it would produce insertion
          // order search. Could also consider implementing DFS. Not clear which
          // is most desirable from a user perspective.
          .order('depth', ascending: true)
          // Within a specific depth level, play the oldest content first as new
          // content in a level might build on other content in that level.
          .order(createdAtCol, ascending: true);
      return paginated(
        transformBuilder,
        chunkSize: single ? 1 : 20,
        chunkLimit: single ? 1 : null,
      );
    }

    if (seedCast != null) {
      // Yield all the casts from the seed cast's conversation first, then play
      // casts from outside the conversation.
      // This is to ensure that, when a user selects a cast, the whole
      // conversation is played through before casts form other conversations.
      yield* orderAndRun(
        getBuilder().neq(idCol, seedCast.id).eq(rootIdCol, seedCast.rootId),
      );
      yield* orderAndRun(
        getBuilder().neq(idCol, seedCast.id).neq(rootIdCol, seedCast.rootId),
      );
    } else {
      yield* orderAndRun(getBuilder());
    }
  }

  // TODO: This will return duplicative elements if casts were added between
  //  requests.
  // Consider client-side de-dup logic or migrating off `range` and onto
  // `gt/lt`.
  Stream<Cast> paginated(
    PostgrestTransformBuilder query, {
    required int chunkSize,
    int? chunkLimit,
  }) async* {
    int soFar = 0;
    while (chunkLimit == null || soFar < chunkLimit * chunkSize) {
      final int upper = soFar + chunkSize;
      // `upper - 1` because range is bad and should feel bad and is inclusive.
      // I mean seriously, what asshole decides a range should have an inclusive
      // upper bound?
      final Iterable<dynamic> rows =
          await query.range(soFar, upper - 1) as Iterable<dynamic>;
      soFar += chunkSize;
      if (rows.isEmpty) {
        // We've run out of casts.
        return;
      }
      for (final dynamic row in rows) {
        final Cast cast = _rowToCast(row);
        yield cast;
      }
    }
  }

  Future<Cast> getCast({required String castId}) async {
    return _rowToCast(await castsReadQuery.select().eq(idCol, castId).single());
  }

  /// Get a cast given an author and the first 8 characters of a cast id.
  ///
  /// Truncated cast ids are used in share links to make the links shorter.
  Future<Cast> getCastFromTruncatedId({
    required String authorUsername,
    required String truncId,
  }) async {
    return _rowToCast(await castsReadQuery
        .select()
        .eq(authorUsernameCol, authorUsername)
        // UUIDs are technically binary blobs not strings so we can't use like.
        .gt('id', '$truncId-0000-0000-0000-000000000000')
        .lt('id', '$truncId-ffff-ffff-ffff-ffffffffffff')
        .single());
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

  Stream<Cast> getPlayQueue({
    required Cast seedCast,
    required List<Topic> filterTopics
  }) {
    return getCasts(
      seedCast: seedCast,
      skipViewed: true,
      filterOutProfile: AuthManager.instance.profile,
      filterTopics: filterTopics,
    );
  }

  Future<void> createCast({
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
    final Cast cast = Cast(
      authorId: supabase.auth.currentUser!.id,
      title: title,
      durationMs: castFile.duration.inMilliseconds,
      audioUrl: audioFileUrl,
      replyTo: replyTo?.id,
      externalUrl: url.emptyToNull,
    );
    final Map<String, dynamic> castMap = await castsWriteQuery
        .insert(_castToRow(cast))
        .select(idCol)
        .single() as Map<String, dynamic>;
    await castsToTopicWriteQuery.insert(topics.map((t) {
      return <String, dynamic>{
        'topic_id': t.id,
        'cast_id': castMap[idCol],
      };
    }).toList());
    // TODO(caseycrogers): this will only log if the create succeeds, consider
    //   wrapping in a finally or something.
    Analytics.instance.logCreate(castId: castMap[idCol] as String);
  }

  Future<void> deleteCast({
    required Cast cast,
  }) async {
    Analytics.instance.logDelete(cast: cast);
    // TODO(caseycrogers): migrate listens to a table with cascading deletes so
    //   that we don't have to issue a separate delete to it.
    await listensQuery.delete().eq('cast_id', cast.id) as List<dynamic>;
    final List<dynamic> rowResult =
        await castsWriteQuery.delete().eq(idCol, cast.id) as List<dynamic>;
    assert(
      rowResult.isNotEmpty,
      'Could not find a cast with id \'${cast.id}\'',
    );
    final List<FileObject> storageResult =
        await castAudioFileBucket.remove([cast.audioPath]);
    assert(
      storageResult.isNotEmpty,
      'Could not find a cast audio file at path \'${cast.audioPath}\'.',
    );
  }

  Future<void> setListened({required Cast cast}) async {
    Analytics.instance.logListen(cast: cast);
    await listensQuery.insert({
      'cast_id': cast.id,
      'user_id': supabase.auth.currentUser!.id,
    });
  }

  Future<void> setSkipped({
    required Cast cast,
    required SkippedReason skippedReason,
    required Duration skippedAt,
  }) async {
    Analytics.instance.logSkip(cast: cast, skippedAt: skippedAt);
    await listensQuery.insert({
      idCol: cast.id,
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

  Future<List<Topic>> getAllTopics() async {
    return (await topicsReadQuery
        .select()
        .order('cast_count')
        .withConverter((dynamic data) {
      return (data as Iterable<dynamic>).map(_rowToTopic).toList();
    }))!;
  }
}

enum SkippedReason {
  nextButton,
  seekButton,
}

Cast _rowToCast(dynamic row) {
  final Map<String, dynamic> rowMap = row as Map<String, dynamic>;
  return Cast.create()
    ..mergeFromProto3Json(
      // TODO(caseycrogers): consider figuring out how to use timestamp.proto.
      <String, dynamic>{
        'created_at_string': rowMap['created_at'].toString(),
        // Note that this only populates some of the values of `reply_cast`
        // because the reply cast is generated from the base table.
        'reply_cast': (rowMap['reply_cast_json'] as Map<String, dynamic>?),
        ...rowMap,
      },
      ignoreUnknownFields: true,
    );
}

Topic _rowToTopic(dynamic row) {
  final Map<String, dynamic> rowMap = row as Map<String, dynamic>;
  return Topic.create()
    ..mergeFromProto3Json(
      rowMap,
      ignoreUnknownFields: true,
    );
}

Map<String, dynamic> _castToRow(Cast cast) {
  return (cast.toProto3Json() as Map<String, dynamic>).toSnakeCase();
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

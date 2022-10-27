import 'dart:io';

import 'package:cast_me_app/business_logic/clients/analytics.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:cast_me_app/util/string_utils.dart';

import 'package:crypto/crypto.dart';
import 'package:ffmpeg_kit_flutter_audio/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/media_information.dart';
import 'package:ffmpeg_kit_flutter_audio/media_information_session.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class CastDatabase {
  CastDatabase._();

  static final CastDatabase instance = CastDatabase._();

  // TODO(caseycrogers): paginate this.
  Stream<Cast> getCasts({
    Profile? filterProfile,
    Profile? filterOutProfile,
    bool skipViewed = false,
    bool oldestFirst = false,
    String? searchTerm,
    int? limit,
  }) async* {
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
    PostgrestTransformBuilder transformBuilder = queryBuilder
        .order(treeUpdatedAtCol, ascending: oldestFirst)
        .order('depth', ascending: true)
        .order(createdAtCol, ascending: oldestFirst);
    if (limit != null) {
      transformBuilder = transformBuilder.limit(limit);
    }
    final List<Cast>? casts =
        await transformBuilder.withConverter((dynamic data) {
      return (data as Iterable<dynamic>).map(_rowToCast).toList();
    });
    for (final Cast cast in casts ?? <Cast>[]) {
      yield cast;
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
      limit: 1,
    ).toList().then((value) => value.isEmpty ? null : value.single);
  }

  Stream<Cast> getPlayQueue({required Cast seedCast}) {
    return getCasts(
      skipViewed: true,
      filterOutProfile: AuthManager.instance.profile,
    ).where((cast) => cast.id != seedCast.id);
  }

  Future<void> createCast({
    required String title,
    required CastFile castFile,
    required Cast? replyTo,
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
    );
    final Map<String, dynamic> castMap = await castsWriteQuery
        .insert(_castToRow(cast))
        .select(idCol)
        .single() as Map<String, dynamic>;
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

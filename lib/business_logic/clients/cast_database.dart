import 'dart:io';

import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/util/string_utils.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class CastDatabase {
  CastDatabase._();

  static final CastDatabase instance = CastDatabase._();

  // TODO(caseycrogers): paginate this.
  Stream<Cast> getCasts() async* {
    final PostgrestResponse<List<Cast>> response = await castsReadQuery
        .select()
        .withConverter((dynamic data) {
          print(data);
          return (data as Iterable<dynamic>)
              .map(_rowToCast)
              .toList();
        })
        .execute()
        .errorToException();
    for (final Cast cast in response.data ?? <Cast>[]) {
      yield cast;
    }
  }

  Future<void> createCast({
    required String title,
    required File file,
  }) async {
    final String fileExt = file.path.split('.').last;
    // Anonymize the file name so we don't get naming conflicts.
    final String fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    await castAudioFileBucket.upload(fileName, file).errorToException();
    final String audioFileUrl = castAudioFileBucket
        .getPublicUrl(fileName)
        .errorToException()
        .data as String;
    final Cast cast = Cast(
      authorId: supabase.auth.currentUser!.id,
      title: title,
      durationMs: 60000,
      audioUrl: audioFileUrl,
    );
    await castsWriteQuery.insert(_castToRow(cast)).execute().errorToException();
  }
}

Cast _rowToCast(dynamic row) {
  return Cast.create()..mergeFromProto3Json(row as Map<String, dynamic>);
}

Map<String, dynamic> _castToRow(Cast cast) {
  return (cast.toProto3Json() as Map<String, dynamic>).toSnakeCase();
}

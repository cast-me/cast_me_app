import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

final profilePicturesBucket =
    supabase.storage.from('profile_pictures');

final castAudioFileBucket = supabase.storage.from('cast-audio-files');

const String createdAtCol = 'created_at';

const String hasViewedCol = 'has_viewed';

const String authorIdCol = 'author_id';

const String castIdCol = 'id';

SupabaseQueryBuilder get profilesQuery => supabase.from('profiles');

SupabaseQueryBuilder get castsWriteQuery => supabase.from('casts');

SupabaseQueryBuilder get castsReadQuery => supabase.from('casts_view');

SupabaseQueryBuilder get viewsQuery => supabase.from('views');

extension GotrueFutureUtil on Future<GotrueResponse> {
  Future<GotrueResponse> errorToException() {
    return then((GotrueResponse value) {
      if (value.statusCode != 200) {
        throw 'Auth failed with error code: ${value.statusCode!}';
      }
      return value;
    });
  }
}

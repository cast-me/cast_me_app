import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

const bool isStaging = true;

final profilePicturesBucket = supabase.storage.from('profile_pictures');

final castAudioFileBucket = supabase.storage.from('cast-audio-files');

const String createdAtCol = 'created_at';

const String hasViewedCol = 'has_viewed';

const String authorIdCol = 'author_id';

const String usernameCol = 'username';

const String displayNameCol = 'display_name';

const String authorDisplayNameCol = 'author_display_name';

const String authorUsernameCol = 'author_username';

const String castIdCol = 'id';

const String titleCol = 'title';

SupabaseQueryBuilder get profilesQuery => supabase.from('profiles');

SupabaseQueryBuilder get fcmRegistrationTokensQuery =>
    supabase.from('fcm_registration_tokens');

SupabaseQueryBuilder get castsWriteQuery =>
    supabase.from(isStaging ? 'staging_casts' : 'casts');

SupabaseQueryBuilder get castsReadQuery =>
    supabase.from(isStaging ? 'staging_casts_view' : 'casts_view');

SupabaseQueryBuilder get listensQuery =>
    supabase.from(isStaging ? 'staging_views' : 'views');

extension GotrueFutureUtil on Future<GotrueResponse> {
  Future<GotrueResponse> errorToException() {
    return then((GotrueResponse value) {
      if (value.statusCode != null && value.statusCode! ~/ 100 != 2) {
        throw 'Auth failed with error code: ${value.statusCode!}';
      }
      return value;
    });
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

final profilePicturesBucket = supabase.storage.from('profile_pictures');

final castAudioFileBucket = supabase.storage.from('cast-audio-files');

const String createdAtString = 'created_at';

SupabaseQueryBuilder get profilesQuery => supabase.from('profiles');

SupabaseQueryBuilder get castsWriteQuery => supabase.from('casts');

SupabaseQueryBuilder get castsReadQuery => supabase.from('casts_view');

extension GotrueFutureUtil on Future<GotrueResponse> {
  Future<GotrueResponse> errorToException() {
    return then((value) {
      if (value.error != null) {
        throw value.error!.message;
      }
      return value;
    });
  }
}

extension PostgresFutureUtil<T> on Future<PostgrestResponse<T>> {
  Future<PostgrestResponse<T>> errorToException() {
    return then((value) {
      if (value.hasError) {
        throw value.error!.message;
      }
      return value;
    });
  }
}

extension StorageFutureUtil<T> on Future<StorageResponse<T>> {
  Future<StorageResponse<T>> errorToException() {
    return then((value) {
      if (value.hasError) {
        throw value.error!.message;
      }
      return value;
    });
  }
}

extension StorageResponseUtil<T> on StorageResponse<T> {
  StorageResponse<T> errorToException() {
    if (hasError) {
      throw error!.message;
    }
    return this;
  }
}

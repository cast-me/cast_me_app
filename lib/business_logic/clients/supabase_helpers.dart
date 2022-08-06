import 'package:supabase_flutter/supabase_flutter.dart';

const String profilePicturesBucketName = 'profile_pictures';

SupabaseQueryBuilder get castMeProfiles =>
    Supabase.instance.client.from('profiles');

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

extension PostgresFutureUtil on Future<PostgrestResponse> {
  Future<PostgrestResponse> errorToException() {
    return then((value) {
      if (value.hasError) {
        throw value.error!.message;
      }
      return value;
    });
  }
}

extension StorageFutureUtil on Future<StorageResponse> {
  Future<StorageResponse> errorToException() {
    return then((value) {
      if (value.hasError) {
        throw value.error!.message;
      }
      return value;
    });
  }
}

extension StorageResponseUtil on StorageResponse {
  StorageResponse errorToException() {
    if (hasError) {
      throw error!.message;
    }
    return this;
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';

late final Future<StorageResponse<Bucket>> profilePictureBucket =
    Supabase.instance.client.storage.getBucket('profile_pictures');

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

extension PostgrsFutureUtil on Future<PostgrestResponse> {
    Future<PostgrestResponse> errorToException() {
        return then((value) {
            if (value.hasError) {
                throw value.error!.message;
            }
            return value;
        });
    }
}

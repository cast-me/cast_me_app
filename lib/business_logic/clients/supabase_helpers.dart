import 'package:supabase_flutter/supabase_flutter.dart';

late final Future<StorageResponse<Bucket>> profilePictureBucket =
    Supabase.instance.client.storage.getBucket('profile_pictures');

SupabaseQueryBuilder get castMeProfiles => Supabase.instance.client.from('profiles');


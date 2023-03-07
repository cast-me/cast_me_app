import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/models/serializable/bulletin_message.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BulletinDatabase {
  BulletinDatabase._();

  static BulletinDatabase instance = BulletinDatabase._();

  @visibleForTesting
  static void reset() {
    instance = BulletinDatabase._();
  }

  Future<BulletinMessage> getMessage() async {
    return _bulletinQuery
        .select<PostgrestMap>()
        .order(createdAtCol, ascending: false)
        .limit(1)
        .single()
        .withConverter((row) => BulletinMessage.fromJson(row));
  }

  SupabaseQueryBuilder get _bulletinQuery =>
      supabase.from(isStaging ? 'staging_bulletin' : 'bulletin');
}

import 'package:cast_me_app/business_logic/clients/analytics.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';

class SocialManager {
  SocialManager._();

  static final instance = SocialManager._();

  Future<void> blockUser({required String id}) async {
    Analytics.instance.logBlockUser(userId: id);
    await blockedUsersQuery.insert({
      userIdCol: AuthManager.instance.user!.id,
      blockedUserIdCol: id,
    });
  }

  Future<void> reportCast({
    required Cast cast,
    required String reason,
  }) async {
    Analytics.instance.logReportCast(cast: cast);
    await reportedCastsQuery.insert({
      userIdCol: AuthManager.instance.user!.id,
      castIdCol: cast.id,
      reasonCol: reason,
    });
  }
}

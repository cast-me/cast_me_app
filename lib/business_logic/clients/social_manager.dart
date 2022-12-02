import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';

class SocialManager {
  SocialManager._();

  static final instance = SocialManager._();

  Future<void> blockUser({required String id}) async {
    await blockedUsersQuery.insert({
      userIdCol: AuthManager.instance.user!.id,
      blockedUserIdCol: id,
    });
  }
}

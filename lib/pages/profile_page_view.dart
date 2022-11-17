// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/app_info.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_submit_button_wrapper.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/profile_page/profile_view.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CastMePage(
      child: Column(
        children: [
          Expanded(child: ProfileView(profile: AuthManager.instance.profile)),
          AuthSubmitButtonWrapper(
            child: ElevatedButton(
              onPressed: () async {
                await AuthManager.instance.signOut();
              },
              child: const Text('Sign out'),
            ),
          ),
          const AppInfo(showIcon: false),
        ],
      ),
    );
  }
}

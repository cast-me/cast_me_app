// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/app_info.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/util/cast_me_modal.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_error_view.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/profile_page/profile_view.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncActionWrapper(
      child: CastMePage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: ProfileView(profile: AuthManager.instance.profile)),
            AsyncElevatedButton(
              action: 'Sign out',
              child: const Text('Sign out'),
              onTap: () async {
                await AuthManager.instance.signOut();
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Color.lerp(Colors.red, Colors.black, .1)!,
                ),
              ),
              onPressed: () async {
                CastMeModal.showMessage(context, const _DeleteAccountModal());
              },
              child: const Text('Delete account'),
            ),
            const AppInfo(showIcon: false),
          ],
        ),
      ),
    );
  }
}

class _DeleteAccountModal extends StatelessWidget {
  const _DeleteAccountModal();

  @override
  Widget build(BuildContext context) {
    return AsyncActionWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Are you sure you want to delete your account?\n'
            'This cannot be undone.',
            textAlign: TextAlign.center,
          ),
          AsyncTextButton(
            text: 'delete account',
            onTap: () async {
              await AuthManager.instance.deleteAccount();
              Navigator.of(context).pop();
            },
          ),
          const AuthErrorView(),
        ],
      ),
    );
  }
}

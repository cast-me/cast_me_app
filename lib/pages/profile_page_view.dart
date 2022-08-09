import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_submit_button_wrapper.dart';
import 'package:flutter/material.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Profile profile = AuthManager.instance.profile;
    return AdaptiveMaterial(
      adaptiveColor: AdaptiveColor.surface,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(profile.profilePictureUrl),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(child: Text('@${profile.username}')),
            Center(child: Text(profile.displayName)),
            AuthSubmitButtonWrapper(
              child: ElevatedButton(
                onPressed: () async {
                  await AuthManager.instance.signOut();
                },
                child: const Text('Sign out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

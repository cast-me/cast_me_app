import 'package:cast_me_app/business_logic/clients/user_manager.dart';
import 'package:cast_me_app/widgets/profile_page/complete_profile_form_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key, required this.child}) : super(key: key);

  // See https://console.firebase.google.com/project/cast-me-app/authentication/providers.
  static const _googleClientId =
      '1081216337666-g8kd3e2tb2djmu5mvah0ghhjcn7vp474.apps.googleusercontent.com';

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SignInScreen(
            providerConfigs: [
              EmailProviderConfiguration(),
            ],
          );
        }
        return ValueListenableBuilder<CastMeUser?>(
          valueListenable: UserManager.instance.currentUser,
          builder: (context, castMeUser, _) {
            if (castMeUser == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!castMeUser.isComplete) {
              return const CompleteProfileFormView();
            }
            return child;
          },
        );
      },
    );
  }
}

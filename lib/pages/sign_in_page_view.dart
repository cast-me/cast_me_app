import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/sign_in_page/complete_profile_view.dart';
import 'package:cast_me_app/widgets/sign_in_page/sign_in_or_register_view.dart';

import 'package:flutter/material.dart';

class SignInPageView extends StatelessWidget {
  const SignInPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveMaterial(
      adaptiveColor: AdaptiveColor.surface,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AnimatedBuilder(
            animation: AuthManager.instance,
            builder: (context, _) {
              final SignInState signInState =
                  AuthManager.instance.signInState;
              switch (signInState) {
                case SignInState.signingIn:
                case SignInState.registering:
                case SignInState.verifyingEmail:
                  return const SignInOrRegisterForm();
                case SignInState.completingProfile:
                  return const CompleteProfileView();
                case SignInState.signedIn:
                  throw Exception('`SignedIn` sign in state should not be '
                      'reachable from the sign in flow widget.');
              }
            },
          ),
        ),
      ),
    );
  }
}
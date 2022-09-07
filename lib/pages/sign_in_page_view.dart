import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_flow/complete_profile_view.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_flow/sign_in_or_register_view.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_flow/verify_email_view.dart';

import 'package:flutter/material.dart';
import 'package:implicit_navigator/implicit_navigator.dart';

class SignInPageView extends StatefulWidget {
  const SignInPageView({Key? key}) : super(key: key);

  @override
  State<SignInPageView> createState() => _SignInPageViewState();
}

class _SignInPageViewState extends State<SignInPageView> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveMaterial(
      adaptiveColor: AdaptiveColor.surface,
      child: SafeArea(
        child: ImplicitNavigator.selectFromListenable<AuthManager, SignInState>(
          listenable: AuthManager.instance,
          selector: () => AuthManager.instance.signInState,
          onPop: (poppedState, stateAfterPop) {
            switch (poppedState) {
              case SignInState.signingIn:
                throw Exception('Should not pop from the base state.');
              case SignInState.registering:
                AuthManager.instance.toggleAccountRegistrationFlow();
                break;
              case SignInState.verifyingEmail:
                AuthManager.instance.exitEmailVerification();
                break;
              case SignInState.completingProfile:
                AuthManager.instance.signOut(returnToRegistering: true);
                break;
              case SignInState.signedIn:
                throw Exception('`SignedIn` sign in state should not be '
                    'reachable from the sign in flow widget.');
            }
          },
          getDepth: (signInState) => SignInState.values.indexOf(signInState),
          builder: (context, signInState, animation, secondaryAnimation) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Builder(
                builder: (context) {
                  switch (signInState) {
                    case SignInState.signingIn:
                      return const SignInOrRegisterForm(isRegistering: false);
                    case SignInState.registering:
                      return const SignInOrRegisterForm(isRegistering: true);
                    case SignInState.verifyingEmail:
                      return const VerifyEmailView();
                    case SignInState.completingProfile:
                      return const CompleteProfileView();
                    case SignInState.signedIn:
                      throw Exception('`SignedIn` sign in state should not be '
                          'reachable from the sign in flow widget.');
                  }
                },
              ),
            );
          },
          transitionsBuilder: ImplicitNavigator.materialRouteTransitionsBuilder,
        ),
      ),
    );
  }
}

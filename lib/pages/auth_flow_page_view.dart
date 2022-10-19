import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/complete_profile_view.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/register_view.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/reset_password_view.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/sign_in_view.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/verify_email_view.dart';

import 'package:flutter/material.dart';
import 'package:implicit_navigator/implicit_navigator.dart';

class AuthFlowPageView extends StatefulWidget {
  const AuthFlowPageView({Key? key}) : super(key: key);

  @override
  State<AuthFlowPageView> createState() => _AuthFlowPageViewState();
}

class _AuthFlowPageViewState extends State<AuthFlowPageView> {
  @override
  Widget build(BuildContext context) {
    return ImplicitNavigator.selectFromListenable<AuthManager, SignInState>(
      listenable: AuthManager.instance,
      selector: () => AuthManager.instance.signInState,
      initialHistory: [
        // Ensures that there is always a base page that is not signed in.
        const ValueHistoryEntry(0, SignInState.signingIn),
      ],
      onPop: (poppedState, stateAfterPop) {
        switch (poppedState) {
          case SignInState.signingIn:
            throw Exception('Should not pop from the base state.');
          case SignInState.registering:
            AuthManager.instance.toggleAccountRegistrationFlow();
            break;
          case SignInState.resettingPassword:
            AuthManager.instance.exitResetPassword();
            break;
          case SignInState.settingNewPassword:
            AuthManager.instance.exitSetNewPassword();
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
        return Builder(
          builder: (context) {
            switch (signInState) {
              case SignInState.signingIn:
                return const SignInView();
              case SignInState.registering:
                return const RegisterFormView();
              case SignInState.resettingPassword:
                return const ResetPasswordView();
              case SignInState.settingNewPassword:
                return const SetNewPasswordView();
              case SignInState.verifyingEmail:
                return const VerifyEmailView();
              case SignInState.completingProfile:
                return const CompleteProfileView();
              case SignInState.signedIn:
                throw Exception('`SignedIn` sign in state should not be '
                    'reachable from the sign in flow widget.');
            }
          },
        );
      },
      transitionsBuilder: ImplicitNavigator.materialRouteTransitionsBuilder,
    );
  }
}

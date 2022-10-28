// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:implicit_navigator/implicit_navigator.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/complete_profile_view.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/register_view.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/reset_password_view.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/sign_in_view.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/verify_email_view.dart';

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
      onPop: AuthManager.instance.handlePop,
      getDepth: (signInState) => SignInState.values.indexOf(signInState),
      builder: (context, signInState, animation, secondaryAnimation) {
        switch (signInState) {
          case SignInState.signingIn:
          case SignInState.signingInThroughProvider:
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
      transitionsBuilder: ImplicitNavigator.materialRouteTransitionsBuilder,
    );
  }
}

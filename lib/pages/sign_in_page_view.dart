import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/sign_in_page/complete_profile_form_view.dart';
import 'package:flutter/material.dart';

import 'package:flutterfire_ui/auth.dart';

class SignInPageView extends StatelessWidget {
  const SignInPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CastMeSignInState? signInState = AuthManager.instance.signInState;
    return AdaptiveMaterial(
      adaptiveColor: AdaptiveColor.surface,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          // Builder is only here to give us a function scope for the switch.
          child: Builder(
            builder: (context) {
              switch (signInState) {
                case CastMeSignInState.signedOut:
                  return CustomEmailSignInForm();
                case CastMeSignInState.completingProfile:
                  return const CompleteProfileFormView();
                case null:
                  throw Exception(
                      '`null` sign in state should not be reachable.');
                case CastMeSignInState.signedIn:
                  throw Exception('`SignedIn` sign in state should not be '
                      'reachable.');
              }
            },
          ),
        ),
      ),
    );
  }
}

class CustomEmailSignInForm extends StatelessWidget {
  CustomEmailSignInForm({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AuthFlowBuilder<EmailFlowController>(
      builder: (context, state, controller, _) {
        switch (state.runtimeType) {
          case AuthFailed:
          case AwaitingEmailAndPassword:
          case SigningIn:
            return Column(
              children: [
                TextField(controller: emailController),
                TextField(controller: passwordController),
                ElevatedButton(
                  onPressed: () {
                    controller.setEmailAndPassword(
                      emailController.text,
                      passwordController.text,
                    );
                  },
                  child: const Text('Sign in'),
                ),
              ],
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

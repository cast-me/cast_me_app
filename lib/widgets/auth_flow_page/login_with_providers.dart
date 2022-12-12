// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_signin_button/flutter_signin_button.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';

class LoginWithProviders extends StatelessWidget {
  const LoginWithProviders({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthManager manager = AuthManager.instance;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProviderButton(
          provider: Buttons.Google,
          text: 'Login with Google',
          signIn: manager.googleSignIn,
        ),
        // Temporarily disabled because they're not working.
        //ProviderButton(
        //  provider: Buttons.FacebookNew,
        //  text: 'Login with Facebook',
        //  signIn: manager.facebookSignIn,
        //),
        //ProviderButton(
        //  provider: Buttons.Twitter,
        //  text: 'Login with Twitter',
        //  signIn: manager.twitterSignIn,
        //),
      ],
    );
  }
}

class ProviderButton extends StatelessWidget {
  const ProviderButton({
    super.key,
    required this.provider,
    required this.text,
    required this.signIn,
  });

  final Buttons provider;
  final String text;
  final AsyncCallback signIn;

  @override
  Widget build(BuildContext context) {
    return AsyncStatusBuilder(
      // TODO: make the sign in button styling match the native buttons.
      action: provider.name,
      child: SignInButton(
        provider,
        text: text,
        onPressed: () async {
          await signIn();
        },
        shape: const StadiumBorder(),
      ),
    );
  }
}

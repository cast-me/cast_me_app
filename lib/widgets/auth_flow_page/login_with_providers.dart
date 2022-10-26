import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_submit_button_wrapper.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginWithProviders extends StatelessWidget {
  const LoginWithProviders({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthManager manager = AuthManager.instance;
    return Column(
      mainAxisSize: MainAxisSize.min,
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
    Key? key,
    required this.provider,
    required this.text,
    required this.signIn,
  }) : super(key: key);

  final Buttons provider;
  final String text;
  final AsyncCallback signIn;

  @override
  Widget build(BuildContext context) {
    return AuthSubmitButtonWrapper(
      // TODO: make the sign in button styling match the native buttons.
      child: SignInButton(
        provider,
        text: text,
        onPressed: () async {
          await signIn();
        },
      ),
    );
  }
}

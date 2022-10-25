import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_submit_button_wrapper.dart';

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
        // TODO: Style these to match CastMe's native buttons.
        AuthSubmitButtonWrapper(
          child: SignInButton(
            Buttons.Google,
            text: 'Login with Google',
            onPressed: () async {
              await manager.googleSignIn();
            },
          ),
        ),
        AuthSubmitButtonWrapper(
          child: SignInButton(
            Buttons.FacebookNew,
            text: 'Login with Facebook',
            onPressed: () async {
              await manager.facebookSignIn();
            },
          ),
        ),
        AuthSubmitButtonWrapper(
          child: SignInButton(
            Buttons.Twitter,
            text: 'Login with Twitter',
            onPressed: () async {
              await manager.twitterSignIn();
            },
          ),
        ),
      ],
    );
  }
}

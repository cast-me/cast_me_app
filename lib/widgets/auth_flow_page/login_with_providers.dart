import 'package:cast_me_app/widgets/auth_flow_page/auth_submit_button_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginWithProviders extends StatelessWidget {
  const LoginWithProviders({
    Key? key,
    required this.onGoogleSubmit,
  }) : super(key: key);

  final AsyncCallback onGoogleSubmit;

  @override
  Widget build(BuildContext context) {
    return AuthSubmitButtonWrapper(
      child: SignInButton(
        Buttons.Google,
        text: 'Login with Google',
        onPressed: () async {
          await onGoogleSubmit();
        },
      ),
    );
  }
}

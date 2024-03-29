// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';

class RegisterSwitcher extends StatelessWidget {
  const RegisterSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isRegistering =
        AuthManager.instance.signInState == SignInState.registering;
    if (isRegistering) {
      return TextButton(
        onPressed: () {
          AuthManager.instance.toggleAccountRegistrationFlow();
        },
        child: const Text(
          'Go back to sign in',
          style: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.underline,
          ),
        ),
      );
    }
    return TextButton(
      onPressed: () async {
        AuthManager.instance.toggleAccountRegistrationFlow();
      },
      child: const Text(
        'Register with email',
        style: TextStyle(
          color: Colors.white,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

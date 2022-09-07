import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_error_view.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_page.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_submit_button_wrapper.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthManager authManager = AuthManager.instance;
    return AuthPage(
      headerText: 'Verify Email',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Check your email to verify your account!\n',
          ),
          AuthSubmitButtonWrapper(
            child: TextButton(
              onPressed: () async {
                await authManager.signIn(
                  email: authManager.emailController.text,
                  password: authManager.passwordController.text,
                );
              },
              child: const Text(
                'Tap here to refresh after you\'ve verified your email',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const AuthErrorView(),
        ],
      ),
    );
  }
}

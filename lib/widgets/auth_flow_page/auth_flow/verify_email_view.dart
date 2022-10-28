// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_error_view.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_submit_button_wrapper.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthManager authManager = AuthManager.instance;
    return CastMePage(
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
                  email: authManager.signInBloc.emailController.text,
                  password: authManager.signInBloc.passwordController.text,
                );
              },
              child: const Text.rich(
                TextSpan(
                  text: 'If the link in your email does not redirect you '
                      'successfully, close and re-open CastMe or\n',
                  children: [
                    TextSpan(
                      text: 'tap here to refresh',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
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

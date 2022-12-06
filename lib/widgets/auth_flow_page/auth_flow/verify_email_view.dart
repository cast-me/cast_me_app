// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_error_view.dart';
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
            'Verification email sent to:\n',
          ),
          Text(
            AuthManager.instance.signInBloc.emailController.text,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          const Text('\nCheck your email to verify your account!\n'),
          const Text('If the link in your email does not redirect you '
              'successfully, close and re-open CastMe or\n'),
          AsyncTextButton(
            text: 'tap here to refresh',
            onTap: () async {
              await authManager.signInEmail(
                email: authManager.signInBloc.emailController.text,
                password: authManager.signInBloc.passwordController.text,
              );
            },
          ),
          const AuthErrorView(),
        ],
      ),
    );
  }
}

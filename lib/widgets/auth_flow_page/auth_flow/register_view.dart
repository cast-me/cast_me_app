// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/auth_form.dart';
import 'package:cast_me_app/widgets/auth_flow_page/register_switcher.dart';

final SignInBloc bloc = AuthManager.instance.signInBloc;

class RegisterFormView extends StatelessWidget {
  const RegisterFormView({Key? key}) : super(key: key);

  SignInBloc get bloc => AuthManager.instance.signInBloc;

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      headerText: 'Register',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: bloc.emailController,
            decoration: const InputDecoration(
              labelText: 'email',
            ),
          ),
          PasswordField(
            controller: bloc.passwordController,
            labelText: 'password',
          ),
          PasswordField(
            controller: bloc.confirmPasswordController,
            labelText: 'confirm password',
          ),
        ],
      ),
      validate: () {
        if (bloc.emailController.text.isEmpty) {
          return false;
        }
        if (bloc.passwordController.text.isEmpty) {
          return false;
        }
        if (bloc.passwordController.text !=
            bloc.confirmPasswordController.text) {
          return false;
        }
        return true;
      },
      onSubmit: () async {
        await AuthManager.instance.createUserEmail(
          email: bloc.emailController.text,
          password: bloc.passwordController.text,
        );
      },
      submitText: 'Register account',
      trailing: const RegisterSwitcher(),
    );
  }
}

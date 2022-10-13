import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/auth_form.dart';
import 'package:cast_me_app/widgets/auth_flow_page/login_with_providers.dart';
import 'package:cast_me_app/widgets/auth_flow_page/register_switcher.dart';
import 'package:cast_me_app/widgets/auth_flow_page/remember_me_view.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  SignInBloc get bloc => AuthManager.instance.signInBloc;

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      headerText: 'Sign in',
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
        ],
      ),
      validate: () {
        if (bloc.emailController.text.isEmpty) {
          return false;
        }
        if (bloc.passwordController.text.isEmpty) {
          return false;
        }
        return true;
      },
      onSubmit: () async {
        await AuthManager.instance.signIn(
          email: bloc.emailController.text,
          password: bloc.passwordController.text,
        );
        await (await SharedPreferences.getInstance()).setString(
          RememberMeView.emailKeyString,
          bloc.emailController.text,
        );
      },
      submitText: 'Sign in',
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          LoginWithProviders(onGoogleSubmit: () async {
            await AuthManager.instance.googleSignIn();
          }),
          const SizedBox(height: 20),
          const RegisterSwitcher(),
          TextButton(
            onPressed: () async {
              AuthManager.instance.toggleResetPassword();
            },
            child: const Text(
              'Reset password',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

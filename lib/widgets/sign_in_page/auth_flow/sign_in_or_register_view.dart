import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_error_view.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_flow/auth_flow_builder.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_submit_button_wrapper.dart';
import 'package:cast_me_app/widgets/sign_in_page/register_switcher.dart';
import 'package:cast_me_app/widgets/sign_in_page/remember_me_view.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInOrRegisterForm extends StatefulWidget {
  const SignInOrRegisterForm({
    Key? key,
    required this.isRegistering,
  }) : super(key: key);

  final bool isRegistering;

  @override
  State<SignInOrRegisterForm> createState() => _SignInOrRegisterFormState();
}

class _SignInOrRegisterFormState extends State<SignInOrRegisterForm> {
  TextEditingController get emailController =>
      AuthManager.instance.emailController;

  TextEditingController get passwordController =>
      AuthManager.instance.passwordController;

  TextEditingController get confirmPasswordController =>
      AuthManager.instance.confirmPasswordController;

  ValueNotifier<bool> currentIsValid = ValueNotifier(false);

  void validate() {
    if (emailController.text.isEmpty) {
      currentIsValid.value = false;
      return;
    }
    if (passwordController.text.isEmpty) {
      currentIsValid.value = false;
      return;
    }
    if (widget.isRegistering &&
        passwordController.text != confirmPasswordController.text) {
      currentIsValid.value = false;
      return;
    }
    currentIsValid.value = true;
    return;
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(validate);
    passwordController.addListener(validate);
    confirmPasswordController.addListener(validate);

    SharedPreferences.getInstance().then((preferences) {
      final String? storedEmail =
          preferences.getString(RememberMeView.emailKeyString);
      if (storedEmail != null && storedEmail.isNotEmpty) {
        emailController.text = storedEmail;
      }
    });
  }

  @override
  void dispose() {
    emailController.removeListener(validate);
    passwordController.removeListener(validate);
    confirmPasswordController.removeListener(validate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthFlowBuilder(builder: (context, authManager, _) {
      return CastMePage(
        isBasePage: !widget.isRegistering,
        headerText: widget.isRegistering ? 'Register' : 'Sign in',
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'email',
              ),
            ),
            PasswordField(
              controller: passwordController,
              labelText: 'password',
            ),
            if (widget.isRegistering)
              PasswordField(
                controller: confirmPasswordController,
                labelText: 'confirm password',
              ),
            const RememberMeView(),
            ValueListenableBuilder<bool>(
              valueListenable: currentIsValid,
              builder: (context, isValid, _) {
                return AuthSubmitButtonWrapper(
                  child: ElevatedButton(
                    onPressed: isValid
                        ? () async {
                            if (widget.isRegistering) {
                              await authManager.createUser(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              return;
                            }
                            await authManager.signIn(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            await (await SharedPreferences.getInstance())
                                .setString(
                              RememberMeView.emailKeyString,
                              emailController.text,
                            );
                          }
                        : null,
                    child: widget.isRegistering
                        ? const Text('Create account')
                        : const Text('Sign in'),
                  ),
                );
              },
            ),
            RegisterSwitcher(isRegistering: widget.isRegistering),
            const AuthErrorView(),
          ],
        ),
      );
    });
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: obscureText,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: GestureDetector(
          child: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        ),
      ),
    );
  }
}

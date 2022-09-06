import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_error_view.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_flow_builder.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_submit_button_wrapper.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInOrRegisterForm extends StatefulWidget {
  const SignInOrRegisterForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInOrRegisterForm> createState() => _SignInOrRegisterFormState();
}

class _SignInOrRegisterFormState extends State<SignInOrRegisterForm> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  ValueNotifier<bool> currentIsValid = ValueNotifier(false);

  bool get isRegistering =>
      AuthManager.instance.signInState == SignInState.registering;

  void validate() {
    if (emailController.text.isEmpty) {
      currentIsValid.value = false;
      return;
    }
    if (passwordController.text.isEmpty) {
      currentIsValid.value = false;
      return;
    }
    if (isRegistering &&
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
          preferences.getString(_rememberedEmailKeyString);
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
      if (authManager.signInState == SignInState.verifyingEmail) {
        // Check on every build as the email will be verified in the background.
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          AuthManager.instance.checkEmailIsVerified(
            email: emailController.text,
            password: passwordController.text,
          );
        });
        return Column(
          children: [
            const Text(
              'Check your email to verify your account!\n'
              'Please note that the verification link in your email will '
              'appear broken, but it is in fact working, come back here after '
              'you\'ve clicked it.',
            ),
            AuthSubmitButtonWrapper(
              child: TextButton(
                onPressed: () async {
                  await AuthManager.instance.checkEmailIsVerified(
                    email: emailController.text,
                    password: passwordController.text,
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
        );
      }
      return Column(
        children: [
          Text(
            isRegistering ? 'Create account' : 'Sign in',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3,
          ),
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
          if (isRegistering)
            PasswordField(
              controller: confirmPasswordController,
              labelText: 'confirm password',
            ),
          const _RememberMeView(),
          ValueListenableBuilder<bool>(
            valueListenable: currentIsValid,
            builder: (context, isValid, _) {
              return AuthSubmitButtonWrapper(
                child: ElevatedButton(
                  onPressed: isValid
                      ? () async {
                          if (isRegistering) {
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
                            _rememberedEmailKeyString,
                            emailController.text,
                          );
                        }
                      : null,
                  child: isRegistering
                      ? const Text('Create account')
                      : const Text('Sign in'),
                ),
              );
            },
          ),
          _RegisterSwitcher(isRegistering: isRegistering),
          const AuthErrorView(),
        ],
      );
    });
  }
}

class _RememberMeView extends StatefulWidget {
  const _RememberMeView({Key? key}) : super(key: key);

  @override
  State<_RememberMeView> createState() => _RememberMeViewState();
}

class _RememberMeViewState extends State<_RememberMeView> {
  final Future<SharedPreferences> preferencesFuture =
      SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: preferencesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final SharedPreferences preferences = snapshot.data!;
        return Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () {
              setState(() {
                preferences.setBool(
                  _rememberMeToggleKeyString,
                  !(preferences.getBool(_rememberMeToggleKeyString) ?? false),
                );
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  activeColor: Colors.black,
                  value:
                      preferences.getBool(_rememberMeToggleKeyString) ?? false,
                  onChanged: (newValue) {
                    setState(() {
                      preferences.setBool(
                          _rememberMeToggleKeyString, newValue!);
                      if (!newValue) {
                        preferences.setString(_rememberedEmailKeyString, '');
                      }
                    });
                  },
                ),
                const AdaptiveText('Remember me'),
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RegisterSwitcher extends StatelessWidget {
  const _RegisterSwitcher({
    Key? key,
    required this.isRegistering,
  }) : super(key: key);

  final bool isRegistering;

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
    return Column(
      children: [
        const SizedBox(height: 20),
        const AdaptiveText('Don\'t have an account?'),
        TextButton(
          onPressed: () async {
            AuthManager.instance.toggleAccountRegistrationFlow();
          },
          child: const Text(
            'Create one!',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
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

const _rememberMeToggleKeyString = 'remember_me';
const _rememberedEmailKeyString = 'remembered_email';

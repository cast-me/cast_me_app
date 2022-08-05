import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:flutter/material.dart';

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
      authManager.signInState == CastMeSignInState.registering;

  final AuthManager authManager = AuthManager.instance;

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
    AuthManager.instance.addListener(validate);
    emailController.addListener(validate);
    passwordController.addListener(validate);
    confirmPasswordController.addListener(validate);
  }

  @override
  void dispose() {
    AuthManager.instance.removeListener(validate);
    emailController.removeListener(validate);
    passwordController.removeListener(validate);
    confirmPasswordController.removeListener(validate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'email',
          ),
        ),
        TextField(
          controller: passwordController,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: 'password',
          ),
        ),
        if (isRegistering)
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'confirm password',
            ),
          ),
        ValueListenableBuilder<bool>(
            valueListenable: currentIsValid,
            builder: (context, isValid, _) {
              return ElevatedButton(
                onPressed: isValid
                    ? () async {
                        if (isRegistering) {
                          await authManager.createUser(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          return;
                        }
                      }
                    : null,
                child: isRegistering
                    ? const Text('Create account')
                    : const Text('Sign in'),
              );
            }),
        _RegisterSwitcher(isRegistering: isRegistering),
        if (authManager.authError != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Auth failed with the following error:',
                textAlign: TextAlign.center,
              ),
              Text(
                'asdfasdf',
                style: TextStyle(color: Theme.of(context).errorColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ],
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
        AuthManager.instance.signInState == CastMeSignInState.registering;
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
            'create one!',
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

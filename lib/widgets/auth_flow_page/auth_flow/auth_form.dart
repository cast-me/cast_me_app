// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_error_view.dart';
import 'package:cast_me_app/widgets/auth_flow_page/remember_me_view.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.headerText,
    required this.body,
    required this.validate,
    required this.onSubmit,
    required this.submitText,
    this.trailing,
  });

  final String headerText;
  final Widget body;
  final bool Function() validate;
  final AsyncCallback onSubmit;
  final String submitText;
  final Widget? trailing;

  @override
  State<AuthForm> createState() => _AuthSignInFormState();
}

class _AuthSignInFormState extends State<AuthForm> {
  late ValueNotifier<bool> currentIsValid = ValueNotifier(widget.validate());

  SignInBloc get bloc => AuthManager.instance.signInBloc;

  void _validate() {
    currentIsValid.value = widget.validate();
  }

  @override
  void initState() {
    super.initState();
    bloc.emailController.addListener(_validate);
    bloc.passwordController.addListener(_validate);
    bloc.confirmPasswordController.addListener(_validate);

    SharedPreferences.getInstance().then((preferences) {
      final String? storedEmail =
          preferences.getString(RememberMeView.emailKeyString);
      if (storedEmail != null && storedEmail.isNotEmpty) {
        bloc.emailController.text = storedEmail;
      }
    });
  }

  @override
  void dispose() {
    bloc.emailController.removeListener(_validate);
    bloc.passwordController.removeListener(_validate);
    bloc.confirmPasswordController.removeListener(_validate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CastMePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.body,
          ValueListenableBuilder<bool>(
            valueListenable: currentIsValid,
            builder: (context, isValid, _) {
              return AsyncElevatedButton(
                action: widget.submitText,
                child: Text(widget.submitText),
                onTap: isValid
                    ? () async {
                        await widget.onSubmit();
                      }
                    : null,
              );
            },
          ),
          if (widget.trailing != null) widget.trailing!,
          const AuthErrorView(),
        ],
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.labelText,
  });

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

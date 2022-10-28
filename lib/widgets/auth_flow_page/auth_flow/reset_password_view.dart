// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/auth_flow_builder.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/auth_form.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  bool emailSent = false;

  SignInBloc get bloc => AuthManager.instance.signInBloc;

  @override
  Widget build(BuildContext context) {
    return AuthFlowBuilder(
      builder: (context, authManager, _) {
        return AuthForm(
          headerText: 'Reset',
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: bloc.emailController,
                decoration: const InputDecoration(
                  labelText: 'email',
                ),
              ),
            ],
          ),
          validate: () {
            if (bloc.emailController.text.isEmpty) {
              return false;
            }
            return true;
          },
          onSubmit: () async {
            await AuthManager.instance
                .sendResetPasswordEmail(email: bloc.emailController.text);
            setState(() {
              emailSent = true;
            });
          },
          submitText: emailSent ? 'Resend email' : 'Send reset email',
          trailing: emailSent
              ? const Text(
                  'If the email you entered is valid, a reset email was sent!\n'
                  'click the link in your email from this device, it will '
                  'redirect you to the password reset form.',
                  textAlign: TextAlign.center,
                )
              : null,
        );
      },
    );
  }
}

class SetNewPasswordView extends StatelessWidget {
  const SetNewPasswordView({Key? key}) : super(key: key);

  SignInBloc get bloc => AuthManager.instance.signInBloc;

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      headerText: 'Reset',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
        if (bloc.passwordController.text.isEmpty ||
            bloc.passwordController.text !=
                bloc.confirmPasswordController.text) {
          return false;
        }
        return true;
      },
      onSubmit: () async {
        await AuthManager.instance
            .setNewPassword(newPassword: bloc.passwordController.text);
      },
      submitText: 'Set password',
    );
  }
}

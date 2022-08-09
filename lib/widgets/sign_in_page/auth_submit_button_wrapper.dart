import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/widgets/common/async_submit_button.dart';
import 'package:flutter/material.dart';

class AuthSubmitButtonWrapper extends StatelessWidget {
  const AuthSubmitButtonWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AsyncSubmitWrapper(
      child: child,
      currentIsSubmitting: AuthManager.instance.select(() {
        return AuthManager.instance.isProcessing;
      }),
    );
  }
}

import 'package:cast_me_app/business_logic/clients/auth_manager.dart';

import 'package:flutter/material.dart';

class AuthErrorView extends StatelessWidget {
  const AuthErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (AuthManager.instance.isProcessing ||
        AuthManager.instance.authError == null) {
      return Container();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Auth failed with the following error:',
          textAlign: TextAlign.center,
        ),
        Text(
          AuthManager.instance.authError.toString(),
          style: TextStyle(color: Theme.of(context).errorColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

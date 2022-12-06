// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/auth_flow_builder.dart';

class AuthErrorView extends StatelessWidget {
  const AuthErrorView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthFlowBuilder(
      builder: (context, authManager, _) {
        if (AuthManager.instance.status.currentAction != null ||
            AuthManager.instance.status.error == null) {
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
              AuthManager.instance.status.error.toString(),
              style: TextStyle(color: Theme.of(context).errorColor),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}

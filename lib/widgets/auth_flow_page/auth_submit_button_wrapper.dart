import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/widgets/common/async_submit_button.dart';
import 'package:flutter/material.dart';

/// Wrap an auth specific async button so that it'll automatically display a
/// loading indicator when the auth manager is processing.
class AuthSubmitButtonWrapper extends StatelessWidget {
  const AuthSubmitButtonWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AsyncSubmitView(
      child: child,
      currentAction: AuthManager.instance.select(
        () => AuthManager.instance.currentAction,
      ),
    );
  }
}

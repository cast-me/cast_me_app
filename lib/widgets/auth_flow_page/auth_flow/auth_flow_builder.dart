// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';

class AuthFlowBuilder extends StatelessWidget {
  const AuthFlowBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext, AuthManager, Widget?) builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AuthManager.instance,
      builder: (context, child) => builder(
        context,
        AuthManager.instance,
        child,
      ),
    );
  }
}

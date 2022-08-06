import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:flutter/material.dart';

class AuthSubmitButtonWrapper extends StatelessWidget {
  const AuthSubmitButtonWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AuthManager.instance,
      builder: (context, child) {
        if (AuthManager.instance.isProcessing) {
          return Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(4),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        return child!;
      },
      child: child,
    );
  }
}

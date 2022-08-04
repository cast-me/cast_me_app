import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/pages/sign_in_page_view.dart';
import 'package:cast_me_app/util/adaptive_material.dart';

import 'package:flutter/material.dart';

class CastMeAuthGate extends StatelessWidget {
  const CastMeAuthGate({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AuthManager authManager = AuthManager.instance;
    return AnimatedBuilder(
      animation: authManager,
      builder: (context, child) {
        if (authManager.isLoading) {
          return const AdaptiveMaterial(
            adaptiveColor: AdaptiveColor.background,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (!authManager.isFullySignedIn) {
          return const SignInPageView();
        }
        return child!;
      },
      child: child,
    );
  }
}

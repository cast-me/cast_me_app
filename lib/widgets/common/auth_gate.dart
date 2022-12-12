// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/pages/auth_flow_page_view.dart';

/// This widget is used to keep users from entering the app if they don't have
/// an internet connection or aren't logged in.
class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AuthManager authManager = AuthManager.instance;
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, connectivityResult) {
        if (connectivityResult.data == ConnectivityResult.none) {
          return const AdaptiveMaterial.surface(
            child: Center(
              child: Text(
                'You are offline!\n'
                'CastMe is currently online only.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return AnimatedBuilder(
          animation: authManager,
          builder: (context, child) {
            if (!authManager.isInitialized) {
              return const AdaptiveMaterial.background(
                child: Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }
            if (!authManager.isFullySignedIn) {
              return const AuthFlowPageView();
            }
            return child!;
          },
          child: child,
        );
      },
    );
  }
}

import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/pages/sign_in_page_view.dart';
import 'package:cast_me_app/util/adaptive_material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AuthManager authManager = AuthManager.instance;
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, connectivityResult) {
          if (connectivityResult.data == ConnectivityResult.none) {
            return const AdaptiveMaterial(
              adaptiveColor: AdaptiveColor.surface,
              child: Center(
                child: AdaptiveText(
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
              if (authManager.isLoading) {
                return const AdaptiveMaterial(
                  adaptiveColor: AdaptiveColor.background,
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
                return const SignInPageView();
              }
              return child!;
            },
            child: child,
          );
        });
  }
}

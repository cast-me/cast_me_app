import 'package:flutter/material.dart';
import 'package:implicit_navigator/implicit_navigator.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({
    Key? key,
    required this.child,
    required this.headerText,
    this.isBasePage = false,
  }) : super(key: key);

  final String headerText;
  final Widget child;
  final bool isBasePage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (!isBasePage) const ImplicitNavigatorBackButton(),
            Expanded(
              child: Text(
                headerText,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline3,
              ),
            ),
          ],
        ),
        child,
      ],
    );
  }
}

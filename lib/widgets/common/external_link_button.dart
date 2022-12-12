// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:url_launcher/url_launcher.dart';

class ExternalLinkButton extends StatelessWidget {
  const ExternalLinkButton({
    super.key,
    required this.uri,
    this.onTap,
  });

  final Uri uri;

  /// Called before
  final void Function(VoidCallback)? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        uri.toString(),
        style: const TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      onPressed: () async {
        if (onTap != null) {
          onTap!(
            () => launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            ),
          );
          return;
        }
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      },
    );
  }
}

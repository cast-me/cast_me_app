import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalLinkButton extends StatelessWidget {
  const ExternalLinkButton({
    Key? key,
    required this.uri,
    this.onTap,
  }) : super(key: key);

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
          onTap!(() => launchUrl(uri));
          return;
        }
        await launchUrl(uri);
      },
    );
  }
}

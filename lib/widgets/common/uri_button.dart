// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:url_launcher/url_launcher.dart';

class UriButton extends StatelessWidget {
  const UriButton({
    super.key,
    required this.uri,
  });

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      },
      child: Row(
        children: [
          Icon(
            Icons.link,
            color: AdaptiveMaterial.onColorOf(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              uri.toString(),
              maxLines: 1,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                decoration: TextDecoration.underline,
                color: AdaptiveMaterial.onColorOf(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

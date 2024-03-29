// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/util/uri_utils.dart';

class ExternalLinkField extends StatelessWidget {
  const ExternalLinkField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  static bool isValid(String url) {
    if (url.isEmpty) {
      return true;
    }
    return UriUtils.tryParse(url, schemes: ['http', 'https']) != null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Link',
            errorText: isValid(controller.text)
                ? null
                : 'Link must be a valid url including \'http\' or \'https\'',
          ),
        );
      },
    );
  }
}

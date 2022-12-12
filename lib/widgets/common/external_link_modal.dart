// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/util/cast_me_modal.dart';
import 'package:cast_me_app/widgets/common/external_link_button.dart';

class ExternalLinkModal {
  static void showMessage(BuildContext context, Uri uri) =>
      CastMeModal.showMessage(
        context,
        _ModalContent(uri: uri),
      );
}

class _ModalContent extends StatelessWidget {
  const _ModalContent({required this.uri});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'You are being redirected to an external link!\n'
          'Tap on the url below to continue to:',
          textAlign: TextAlign.center,
        ),
        ExternalLinkButton(
          uri: uri,
          onTap: (launch) {
            Navigator.of(context).pop();
            launch();
          },
        ),
      ],
    );
  }
}

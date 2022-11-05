// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/util/adaptive_material.dart';

class CastMeModal extends StatelessWidget {
  const CastMeModal({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  static void showMessage(
    BuildContext context,
    Widget child, {
    bool postFrame = false,
  }) {
    void showModal() {
      showDialog<void>(
        context: context,
        builder: (context) {
          return CastMeModal(child: child);
        },
      );
    }

    if (postFrame) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          showModal();
        },
      );
      return;
    }
    showModal();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: double.infinity,
            child: AdaptiveMaterial(
              adaptiveColor: AdaptiveColor.surface,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
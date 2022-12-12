// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';

class CastMeModal extends StatelessWidget {
  const CastMeModal._({
    required this.child,
  });

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
          return CastMeModal._(child: child);
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
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: double.infinity,
          child: AdaptiveMaterial(
            material: AdaptiveMaterialType.surface,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

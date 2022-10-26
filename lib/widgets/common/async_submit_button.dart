import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@Deprecated('Is being replaced by async_action_wrapper.dart')
class AsyncSubmitButton extends StatelessWidget {
  AsyncSubmitButton({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  final Widget child;
  final ValueNotifier<String?> currentIsSubmitting = ValueNotifier(null);
  final ValueNotifier<String?> currentErrorMessage = ValueNotifier(null);
  final AsyncCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AsyncSubmitView(
      child: ElevatedButton(
        child: child,
        onPressed: onPressed != null
            ? () async {
                currentIsSubmitting.value = '';
                await onPressed!().whenComplete(
                  () {
                    currentIsSubmitting.value = null;
                  },
                ).onError((error, stackTrace) {
                  currentErrorMessage.value = error.toString();
                  FirebaseCrashlytics.instance.recordError(error, stackTrace);
                });
              }
            : null,
      ),
      currentAction: currentIsSubmitting,
      currentErrorMessage: currentErrorMessage,
    );
  }
}

class AsyncSubmitView extends StatelessWidget {
  const AsyncSubmitView({
    Key? key,
    required this.child,
    required this.currentAction,
    this.currentErrorMessage,
  }) : super(key: key);

  final Widget child;
  final ValueListenable<String?> currentAction;
  final ValueListenable<String?>? currentErrorMessage;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: currentAction,
      builder: (context, action, _) {
        if (action != null) {
          return Container(
            height: 46,
            width: 46,
            padding: const EdgeInsets.all(4),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            child,
            if (currentErrorMessage != null)
              ValueListenableBuilder<String?>(
                valueListenable: currentErrorMessage!,
                builder: (context, errorMessage, _) {
                  if (errorMessage != null) {
                    return Text(
                      errorMessage,
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .error,
                      ),
                    );
                  }
                  return const SizedBox(height: 0);
                },
              ),
          ],
        );
      },
    );
  }
}

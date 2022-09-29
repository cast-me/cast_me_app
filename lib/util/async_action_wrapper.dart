import 'dart:developer';

import 'package:cast_me_app/util/string_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef Wrapper = Future<void> Function(String, AsyncCallback);

abstract class AsyncActionWrapper {
  final ValueNotifier<AsyncActionStatus> status =
      ValueNotifier(AsyncActionStatus.empty());

  Future<void> wrap(
    String label,
    AsyncCallback action,
  ) async {
    _start();
    await action().then(
      (value) async {
        _finish(null);
        return value;
      },
      onError: (Object error, StackTrace stackTrace) {
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
        log(
          'Auth action failed.',
          error: error,
          stackTrace: stackTrace,
        );
        _finish(error);
        throw error;
      },
    );
  }

  void _start() {
    status.value = AsyncActionStatus(
      isProcessing: true,
      error: null,
    );
  }

  void _finish(Object? error) {
    status.value = AsyncActionStatus(
      isProcessing: false,
      error: error,
    );
  }
}

class AsyncActionStatus extends ChangeNotifier {
  AsyncActionStatus({
    required this.isProcessing,
    required this.error,
  });

  AsyncActionStatus.empty()
      : isProcessing = false,
        error = null;

  final Object? error;
  final bool isProcessing;
}


class AsyncErrorView extends StatelessWidget {
  const AsyncErrorView({
    Key? key,
    this.errorPrefix,
    required this.currentStatus,
  }) : super(key: key);

  final String? errorPrefix;
  final ValueListenable<AsyncActionStatus> currentStatus;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AsyncActionStatus>(
      valueListenable: currentStatus,
      builder: (context, status, _) {
        if (status.isProcessing || status.error == null) {
          return Container();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (errorPrefix != null)
              Text(
                errorPrefix!,
                textAlign: TextAlign.center,
              ),
            Text(
              status.error.toString().truncate(80),
              style: TextStyle(color: Theme.of(context).errorColor),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}

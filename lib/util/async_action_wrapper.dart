// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Project imports:
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/util/string_utils.dart';

class AsyncActionWrapper extends InheritedWidget {
  AsyncActionWrapper({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  final ValueNotifier<AsyncActionStatus> status =
      ValueNotifier(AsyncActionStatus.empty());

  static AsyncActionWrapper of(BuildContext context) {
    final AsyncActionWrapper? result =
        context.findAncestorWidgetOfExactType<AsyncActionWrapper>();
    assert(result != null, 'No AsyncActionWrapper found in context');
    return result!;
  }

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
          '$label failed',
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

  @override
  bool updateShouldNotify(AsyncActionWrapper oldWidget) {
    return false;
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
  }) : super(key: key);

  final String? errorPrefix;

  @override
  Widget build(BuildContext context) {
    final ValueListenable<AsyncActionStatus> currentStatus =
        AsyncActionWrapper.of(context).status;
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

class ProcessingView extends StatefulWidget {
  const ProcessingView({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<ProcessingView> createState() => _ProcessingViewState();
}

class _ProcessingViewState extends State<ProcessingView> {
  RenderBox? box;

  @override
  Widget build(BuildContext context) {
    final AsyncActionWrapper wrapper = AsyncActionWrapper.of(context);
    return ValueListenableBuilder<bool>(
      valueListenable: wrapper.status.map((status) => status.isProcessing),
      builder: (context, isProcessing, child) {
        if (isProcessing) {
          return Container(
            height: box!.size.height,
            width: box!.size.width,
            padding: const EdgeInsets.all(12),
            alignment: Alignment.center,
            child: const AspectRatio(
              aspectRatio: 1,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 4,
              ),
            ),
          );
        }
        return Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              box = context.findRenderObject() as RenderBox;
            });
            return child!;
          },
        );
      },
      child: widget.child,
    );
  }
}

class AsyncTextButton extends StatelessWidget {
  const AsyncTextButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final AsyncCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ProcessingView(
      child: TextButton(
        onPressed: () async {
          await AsyncActionWrapper.of(context).wrap('text', onTap);
        },
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

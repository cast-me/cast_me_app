// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/util/string_utils.dart';
import 'package:cast_me_app/widgets/common/cast_menu.dart';

class AsyncActionWrapper extends StatefulWidget {
  const AsyncActionWrapper({
    super.key,
    this.controller,
    required this.child,
  });

  final AsyncActionController? controller;
  final Widget child;

  static AsyncActionController of(BuildContext context) {
    return context
        .findAncestorWidgetOfExactType<_ControllerProvider>()!
        .controller;
  }

  @override
  State<AsyncActionWrapper> createState() => _AsyncActionWrapperState();
}

class _AsyncActionWrapperState extends State<AsyncActionWrapper> {
  AsyncActionController? fallbackController;

  @override
  Widget build(BuildContext context) {
    if (widget.controller == null && fallbackController == null) {
      fallbackController = AsyncActionController();
    } else if (widget.controller != null && fallbackController != null) {
      fallbackController = null;
    }
    return _ControllerProvider(
      controller: widget.controller ?? fallbackController!,
      child: widget.child,
    );
  }
}

class _ControllerProvider extends InheritedWidget {
  const _ControllerProvider({
    required this.controller,
    required super.child,
  });

  final AsyncActionController controller;

  @override
  bool updateShouldNotify(_ControllerProvider oldWidget) {
    return false;
  }
}

class AsyncActionController extends ChangeNotifier {
  AsyncActionStatus _status = AsyncActionStatus.empty();

  AsyncActionStatus get status => _status;

  void _start(String action) {
    _status = AsyncActionStatus.start(action);
    notifyListeners();
  }

  void _finish(Object? error) {
    _status = AsyncActionStatus.finish(error);
    notifyListeners();
  }

  Future<T> wrap<T>(
    String label,
    Future<T> Function() action,
  ) {
    _start(label);
    return action().then(
      (value) async {
        _finish(null);
        return value;
      },
      onError: (Object error, StackTrace stackTrace) {
        _finish(error);
        throw error;
      },
    ).whenComplete(
      () => notifyListeners(),
    );
  }
}

class AsyncActionStatus {
  AsyncActionStatus.empty()
      : currentAction = null,
        error = null;

  AsyncActionStatus.start(this.currentAction) : error = null;

  AsyncActionStatus.finish([this.error]) : currentAction = null;

  final String? currentAction;
  final Object? error;

  bool get isProcessing => currentAction != null;
}

class AsyncErrorView extends StatelessWidget {
  const AsyncErrorView({
    super.key,
    this.errorPrefix,
  });

  final String? errorPrefix;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AsyncActionStatus>(
      valueListenable: AsyncActionWrapper.of(context).select((w) => w.status),
      builder: (context, status, _) {
        if (status.isProcessing || status.error == null) {
          return Container();
        }
        return ErrorText(
          errorPrefix: errorPrefix,
          error: status.error!,
        );
      },
    );
  }
}

class ErrorText extends StatelessWidget {
  const ErrorText({
    super.key,
    this.errorPrefix,
    required this.error,
  });

  final String? errorPrefix;
  final Object error;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (errorPrefix != null)
          Text(
            errorPrefix!,
            textAlign: TextAlign.center,
          ),
        Text(
          error.toString().truncate(80),
          style: TextStyle(color: Theme.of(context).errorColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class AsyncStatusBuilder extends StatefulWidget {
  const AsyncStatusBuilder({
    super.key,
    required this.action,
    required this.child,
  });

  final String action;
  final Widget child;

  @override
  State<AsyncStatusBuilder> createState() => _AsyncStatusBuilderState();
}

class _AsyncStatusBuilderState extends State<AsyncStatusBuilder> {
  RenderBox? box;

  @override
  Widget build(BuildContext context) {
    final AsyncActionController wrapper = AsyncActionWrapper.of(context);
    return ValueListenableBuilder<AsyncActionStatus>(
      valueListenable: wrapper.select((w) => w.status),
      builder: (context, status, child) {
        if (status.currentAction == widget.action) {
          return SizedBox(
            height: box!.size.height,
            width: box!.size.width,
            child: Container(
              padding: const EdgeInsets.all(12),
              alignment: Alignment.center,
              child: const AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 4,
                ),
              ),
            ),
          );
        }
        return Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              box = context.findRenderObject() as RenderBox;
            });
            return IgnorePointer(
              // Don't allow multi-presses.
              ignoring: status.isProcessing,
              child: Opacity(
                // If another button under this wrapper is currently processing,
                // then dim the child widget to indicate that it is not enabled.
                opacity: status.isProcessing ? .5 : 1,
                child: widget.child,
              ),
            );
          },
        );
      },
    );
  }
}

class AsyncTextButton extends StatelessWidget {
  const AsyncTextButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final AsyncCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AsyncStatusBuilder(
      action: text,
      child: TextButton(
        onPressed: () async {
          await AsyncActionWrapper.of(context).wrap(text, onTap);
        },
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class AsyncMenuButton extends StatelessWidget {
  const AsyncMenuButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isEnabled = true,
  });

  final IconData icon;
  final String text;
  final AsyncCallback onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return AsyncStatusBuilder(
      action: text,
      child: MenuButton(
        icon: icon,
        text: text,
        onTap: onTap,
        isEnabled: isEnabled,
      ),
    );
  }
}

class AsyncElevatedButton extends StatelessWidget {
  const AsyncElevatedButton({
    super.key,
    required this.action,
    required this.child,
    required this.onTap,
  });

  final String action;
  final Widget child;
  final AsyncCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AsyncStatusBuilder(
      action: action,
      child: ElevatedButton(
        onPressed: onTap == null
            ? null
            : () async {
                await AsyncActionWrapper.of(context).wrap(action, onTap!);
              },
        child: child,
      ),
    );
  }
}

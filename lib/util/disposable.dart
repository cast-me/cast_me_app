// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

abstract class Disposable {
  final List<AsyncCallback> _disposeFunctions = [];

  void registerDisposeFunction(AsyncCallback disposeFunction) {
    _disposeFunctions.add(disposeFunction);
  }

  void registerSubscription(StreamSubscription subscription) {
    registerDisposeFunction(subscription.cancel);
  }

  Future<void> dispose() async {
    for (final disposeFunction in _disposeFunctions) {
      await disposeFunction();
    }
  }
}

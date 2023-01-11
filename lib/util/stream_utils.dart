// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

extension StreamUtils<T> on Stream<T> {
  ValueListenable<T?> toListenable() {
    final ValueNotifier<T?> proxyNotifier = ValueNotifier(null);
    listen((event) {
      proxyNotifier.value = event;
    });
    return proxyNotifier;
  }


  /// Same as above, but waits until the first stream even to return a value
  /// listenable rather than synchronously initializing it with null.
  Future<ValueListenable<T>> asyncToListenable() async {
    final Completer<ValueListenable<T>> completer = Completer();
    ValueNotifier<T>? proxyNotifier;
    listen((event) {
      if (proxyNotifier == null) {
        proxyNotifier = ValueNotifier(event);
        completer.complete(proxyNotifier);
        return;
      }
      proxyNotifier!.value = event;
    });
    return completer.future;
  }
}

import 'package:flutter/foundation.dart';

extension StreamUtils<T> on Stream<T> {
  ValueListenable<T?> toListenable() {
    final ValueNotifier<T?> proxyNotifier = ValueNotifier(null);
    listen((event) {
      proxyNotifier.value = event;
    });
    return proxyNotifier;
  }
}
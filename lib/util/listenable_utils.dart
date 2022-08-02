import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ValueListenablePageController extends PageController
    implements ValueListenable<double> {
  double _pageValue = 0;

  @override
  int get initialPage => _pageValue.round();

  @override
  void dispose() {
    super.dispose();
    // If it's disposed mid-transition we should round to the nearest page.
    _pageValue = _pageValue.roundToDouble();
  }

  @override
  void notifyListeners() {
    // We need to save the current page as a separate value so that it persists
    // as the page controller is destroyed and recreated.
    _pageValue = page!;
    super.notifyListeners();
  }

  @override
  double get value => _pageValue;
}

extension ValueListenableExtension<T> on ValueListenable<T> {
  ValueListenable<R> map<R>(
    R Function(T value) mapper,
  ) {
    final ValueNotifier<R> proxyNotifier = ValueNotifier(mapper(value));
    void onValueChanged() {
      proxyNotifier.value = mapper(value);
    }

    addListener(onValueChanged);
    return proxyNotifier;
  }
}

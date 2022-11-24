// Dart imports:
import 'dart:async';

// Flutter imports:
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

extension ValueNotifierUtils<T> on ValueNotifier<T> {
  StreamSubscription<T> updateFromStream(Stream<T> stream) {
    return stream.listen((event) {
      value = event;
    });
  }
}

extension ValueListenableUtils<T> on ValueListenable<T> {
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

extension ListUtils<K, V> on List<V> {
  List<V> toggled(V element, {K Function(V)? byKey}) {
    final List<V> lst = toList();
    final int index = indexWhere((v) {
      if (byKey != null) {
        return byKey(v) == byKey(element);
      }
      return v == element;
    });
    if (index != -1) {
      return lst..removeAt(index);
    }
    return lst..add(element);
  }
}

extension ListValueNotifier<K, V> on ValueNotifier<List<V>> {
  void toggle(V element, {K Function(V)? byKey}) {
    value = value.toggled(element, byKey: byKey);
  }
}

extension ListenableUtils on Listenable {
  ValueListenable<T> select<T>(T Function() selector) {
    final ValueNotifier<T> proxyListenable = ValueNotifier(selector());
    addListener(() {
      proxyListenable.value = selector();
    });
    return proxyListenable;
  }
}

class HistoryValueNotifier<T> extends ValueNotifier<T> {
  HistoryValueNotifier(T value) : super(value);

  final List<T> _history = [];

  @override
  set value(T newValue) {
    _history.add(value);
    super.value = newValue;
  }

  bool get canUndo => _history.isNotEmpty;

  void undo() {
    assert(_history.isNotEmpty);
    value = _history.removeLast();
  }
}

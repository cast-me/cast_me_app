import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

class FirestoreValueNotifier<T> extends ValueNotifier<T?> {
  FirestoreValueNotifier({
    required this.documentReference,
    required this.docToValue,
    required this.valueToObject,
  }) : super(null) {
    _subscription = documentReference.snapshots().map((doc) {
      if (doc.data() == null) {
        return null;
      }
      return docToValue(doc);
    }).listen((newValue) {
      value = newValue;
    });
  }

  late final StreamSubscription _subscription;

  final DocumentReference<Map<String, dynamic>> documentReference;
  final T Function(DocumentSnapshot<Map<String, dynamic>>) docToValue;
  final Map<String, dynamic> Function(T?) valueToObject;

  @override
  set value(T? newValue) {
    if (value == newValue) {
      return;
    }
    documentReference
        .set(valueToObject(newValue))
        .then((_) => super.value = newValue);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

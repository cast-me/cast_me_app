// Package imports:
import 'package:basic_utils/basic_utils.dart';

extension MapUtils<K, V> on Map<K, V> {
  V getOrElse(K key, V defaultValue) {
    if (containsKey(key)) {
      return this[key]!;
    } else {
      this[key] = defaultValue;
      return defaultValue;
    }
  }

  Iterable<T> mapDown<T>(T Function(K key, V value) f) {
    return entries.map((e) => f(e.key, e.value));
  }
}

extension NotShittyList<T> on List<T> {
  T get(int index, {required T orElse}) =>
      index < length ? this[index] : orElse;

  void sortBy(Comparable Function(T) toComparable) {
    sort((a, b) => toComparable(a).compareTo(toComparable(b)));
  }

  List<T> sortedBy(Comparable Function(T) toComparable) {
    return toList()..sort((a, b) => toComparable(a).compareTo(toComparable(b)));
  }
}

extension NotShittIterable<T> on Iterable<T> {
  Iterable<T>? get emptyToNull => isEmpty ? null : this;

  Iterable<T> separated(T separator) {
    if (isEmpty) {
      return [];
    }
    final List<T> ret = [];
    final Iterator<T> iter = iterator;
    for (int i = 0; i < 2 * length - 1; i++) {
      if (i % 2 == 0) {
        iter.moveNext();
        ret.add(iter.current);
      } else {
        ret.add(separator);
      }
    }
    return ret;
  }
}

extension JsonString on Map<String, dynamic> {
  Map<String, dynamic> toSnakeCase() {
    return map<String, dynamic>((String key, dynamic value) {
      return MapEntry<String, dynamic>(
        StringUtils.camelCaseToLowerUnderscore(key),
        value is Map<String, dynamic> ? value.toSnakeCase() : value,
      );
    });
  }

  Map<String, dynamic> jsonMap({
    String Function(String)? mapKey,
    dynamic Function(String, dynamic)? mapValue,
  }) {
    return map<String, dynamic>(
      (String key, dynamic value) {
        final newKey = mapKey != null ? mapKey(key) : key;
        if (value is Map<String, dynamic>) {
          return MapEntry<String, dynamic>(
            newKey,
            value.jsonMap(mapKey: mapKey, mapValue: mapValue),
          );
        }
        if (value is Iterable<Map<String, dynamic>>) {
          return MapEntry<String, dynamic>(
            newKey,
            value.map(
              (element) => element.jsonMap(mapKey: mapKey, mapValue: mapValue),
            ),
          );
        }
        if (value is Iterable<dynamic> && mapValue != null) {
          return MapEntry<String, dynamic>(
            newKey,
            value.map<dynamic>((dynamic v) => mapValue(key, v)),
          );
        }
        return MapEntry<String, dynamic>(
          newKey,
          mapValue != null ? mapValue(key, value) : value,
        );
      },
    );
  }
}

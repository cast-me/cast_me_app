extension StringUtilsExtension on String {
  String? get emptyToNull => isEmpty ? null : this;

  Iterable<String> get iterable sync* {
    for (var i = 0; i < length; i++) {
      yield this[i];
    }
  }

  String truncate(int cutoff) {
    return (length <= cutoff)
        ? this
        : '${substring(0, cutoff).trimRight()}...';
  }
}

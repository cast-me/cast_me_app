extension StringUtils on String {
  String? get zeroToNull => isEmpty ? null : this;
}
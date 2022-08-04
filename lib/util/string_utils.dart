extension StringUtils on String {
  String? get emptyToNull => isEmpty ? null : this;
}
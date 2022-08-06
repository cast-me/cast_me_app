import 'package:basic_utils/basic_utils.dart';

extension StringUtilsExtension on String {
  String? get emptyToNull => isEmpty ? null : this;
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
}

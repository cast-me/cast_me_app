extension UriUtils on Uri {
  static Uri? tryParse(String url, {List<String>? schemes}) {
    if (url.isEmpty) {
      return null;
    }
    try {
      final Uri uri = Uri.parse(url);
      if (schemes == null || schemes.contains(uri.scheme)) {
        return uri;
      }
    } on FormatException {
      // Catch this so that null is returned if parsing fails.
    }
    return null;
  }
}

import 'package:uni_links/uni_links.dart';

/// Routes incoming deep links using the `getcastme` domain.
///
/// Here's a command to test this on android:
///   adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://getcastme.com"'
///
/// TODO: Consider wrapping this and other handlers to a widget so that they can
///   surface errors to the user.
class DeepLinkHandler {
  DeepLinkHandler._();

  static Future<void> register(void Function(List<String>) handlePath) async {
    void _handleLink(Uri? uri) {
      if (uri == null || uri.host != 'getcastme.com') {
        return;
      }
      handlePath(uri.pathSegments);
    }
    _handleLink(await getInitialUri());
    uriLinkStream.listen(_handleLink);
  }
}

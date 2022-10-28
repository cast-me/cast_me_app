// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:uni_links/uni_links.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';

/// Routes incoming deep links using the `getcastme` domain.
///
/// Here's a command to test this on android:
///   adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://getcastme.com"'
///
/// TODO: Consider wrapping this and other handlers in a widget so that they can
///   surface errors to the user.
class DeepLinkHandler {
  DeepLinkHandler._();

  static VoidCallback? _deferredUntilSignIn;

  static Future<void> register(void Function(List<String>) handlePath) async {
    AuthManager.instance.addListener(() {
      if (AuthManager.instance.isFullySignedIn) {
        _deferredUntilSignIn?.call();
        _deferredUntilSignIn = null;
      }
    });
    void _handleLink(Uri? uri) {
      if (uri == null) {
        return;
      }
      if (uri.host != 'getcastme.com' && uri.host != 'www.getcastme.com') {
        return;
      }
      if (!AuthManager.instance.isFullySignedIn) {
        // Handle the path after we've logged in.
        _deferredUntilSignIn = () => handlePath(uri.pathSegments);
        return;
      }
      handlePath(uri.pathSegments);
    }

    _handleLink(await getInitialUri());
    uriLinkStream.listen(_handleLink);
  }
}

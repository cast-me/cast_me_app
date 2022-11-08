// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:cast_me_app/util/app_info.dart';
import 'package:cast_me_app/util/cast_me_modal.dart';

/// Displays update messages to the user.
///
/// There are two kinds of messages displayed:
///  - First open message
///  - Version update message
///
/// The first open message is used to welcome the suer to the app and is only
/// ever displayed once.
/// The version update message is displayed the first time the user opens the
/// app with that version. If the first open message is displayed, the version
/// message will be skipped for that version so that the user doesn't have to
/// read two messages back to back.
/// If no version message matching the current version is found in
/// [updateMessages], no message will be displayed at all.
class UpdateMessage extends StatelessWidget {
  const UpdateMessage({
    Key? key,
    required this.updateMessages,
    required this.child,
  }) : super(key: key);

  /// A mapping of version numbers (ie '1.1.5') to message widgets to be
  /// displayed for that version.
  final Map<String, Widget> updateMessages;
  final Widget child;

  static const _firstOpenStr = 'update_message_first_open';

  static String get _hasDisplayedStr => 'update_message_v$_installedVersion';

  /// Whether or not this is the first ever open of the app, in which case we
  /// should display a welcome message instead of a changelog.
  static late bool _displayFirstOpenMsg;

  /// Whether or not the version message (or open message) has already been
  /// displayed.
  static late bool _hasDisplayed;

  /// The currently installed version.
  static late final String _installedVersion;

  static Future<void> register(Future<PackageInfo> packageInfo) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    _installedVersion = (await packageInfo).version;
    _displayFirstOpenMsg = preferences.getBool(_firstOpenStr) ?? true;
    _hasDisplayed = preferences.getBool(_hasDisplayedStr) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_displayFirstOpenMsg) {
      _displayFirstOpenMsg = false;
      CastMeModal.showMessage(
        context,
        const WelcomeMessageContent(),
        postFrame: true,
      );
    } else if (!_hasDisplayed && !_displayFirstOpenMsg) {
      final Widget? messageForVersion = updateMessages[_installedVersion];
      if (messageForVersion != null) {
        CastMeModal.showMessage(
          context,
          UpdateMessageContent(child: messageForVersion),
          postFrame: true,
        );
      }
    }
    if (_displayFirstOpenMsg || !_hasDisplayed) {
      SharedPreferences.getInstance().then((p) {
        p.setBool(_firstOpenStr, false);
        p.setBool(_hasDisplayedStr, true);
      });
      // Override locally too so that we don't re-display during this session.
      _hasDisplayed = true;
    }
    return Container(child: child);
  }
}

class CastMeUpdates extends StatelessWidget {
  const CastMeUpdates({
    Key? key,
    required this.updates,
  }) : super(key: key);

  final List<String> updates;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: updates.map((msg) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(' - '),
            Text(msg),
          ],
        );
      }).toList(),
    );
  }
}

final discordUrl = Uri.parse('https://discord.gg/uGRN9hBbnv');

class WelcomeMessageContent extends StatelessWidget {
  const WelcomeMessageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome to CastMe!',
          style: Theme.of(context).textTheme.headline5,
        ),
        const Text('\nThank you for being an early adopter!\n'),
        const Text('Please join our discord server to provide feedback and '
            'chat with other early adopters!'),
        Center(
          child: TextButton(
            onPressed: () {
              launchUrl(discordUrl);
            },
            child: const Text(
              'CastMe Discord Server',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        const AppInfo(),
      ],
    );
  }
}

class UpdateMessageContent extends StatelessWidget {
  const UpdateMessageContent({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome to version ${UpdateMessage._installedVersion}!',
          style: Theme.of(context).textTheme.headline5,
        ),
        const Text('\nNew features:'),
        child,
        Center(
          child: TextButton(
            onPressed: () {
              launchUrl(discordUrl);
            },
            child: const Text(
              'Provide Feedback (opens Discord)',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        const AppInfo(),
      ],
    );
  }
}

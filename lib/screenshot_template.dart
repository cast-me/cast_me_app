// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_frame/device_frame.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/main.dart';
import 'package:cast_me_app/widgets/common/update_message.dart';

Future<void> main() async {
  WidgetsApp.debugAllowBannerOverride = false;
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: invalid_use_of_visible_for_testing_member
  UpdateMessage.disable();
  await initialize();
  await initializeAuth();
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  runApp(
    CastMeScreenshotTemplate(
      headerText: 'Join the town square!',
      config: ScreenshotConfig(
        category: '',
        device: Devices.android.largeTablet,
      ),
      locale: const Locale('es'),
    ),
  );
}

const double kPad = 6;
const double kTopPad = 50;

class ScreenshotTemplate extends StatelessWidget {
  ScreenshotTemplate({
    super.key,
    required this.header,
    required this.background,
    required this.child,
    required ScreenshotConfig screenshotConfig,
  })  : device = screenshotConfig.device,
        outputWidth = screenshotConfig.outputWidth,
        outputHeight = screenshotConfig.outputHeight;

  final Widget header;
  final Widget background;
  final Widget child;
  final DeviceInfo device;
  final double outputWidth;
  final double outputHeight;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(top: kTopPad) /
                MediaQuery.of(context).devicePixelRatio,
            child: Transform.scale(
              alignment: Alignment.topLeft,
              // Separate x and y because they may be off by a rounding error.
              scaleX: (outputWidth / device.screenSize.width) /
                  MediaQuery.of(context).devicePixelRatio,
              scaleY: (outputHeight / device.screenSize.height) /
                  MediaQuery.of(context).devicePixelRatio,
              child: Align(
                alignment: Alignment.topLeft,
                child: Material(
                  type: MaterialType.transparency,
                  child: SizedBox(
                    width: device.screenSize.width,
                    height: device.screenSize.height,
                    child: Stack(
                      children: [
                        background,
                        Padding(
                          padding: const EdgeInsets.all(4 * kPad),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 2 * kPad),
                                child: header,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2 * kPad),
                                  child: DeviceFrame(
                                    device: device,
                                    screen: _SimulatedNavBar(child: child),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CastMeScreenshotTemplate extends StatelessWidget {
  const CastMeScreenshotTemplate({
    super.key,
    required this.headerText,
    required this.locale,
    required this.config,
  });

  final String headerText;
  final Locale locale;
  final ScreenshotConfig config;

  @override
  Widget build(BuildContext context) {
    return ScreenshotTemplate(
      header: Container(
        constraints: const BoxConstraints(minHeight: 115),
        alignment: Alignment.center,
        child: Text(
          headerText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      background: Container(color: Colors.white),
      screenshotConfig: config,
      child: const CastMeApp(),
    );
  }
}

class ScreenshotConfig {
  ScreenshotConfig({
    required this.category,
    required this.device,
    double? outputWidth,
    double? outputHeight,
  })  : assert(
            ((outputWidth ?? device.screenSize.width) /
                            (outputHeight ?? device.screenSize.height) -
                        device.screenSize.aspectRatio)
                    .abs() <
                .1,
            'Different aspect ratio:\n'
            'device:${device.screenSize.width}x${device.screenSize.height}\n'
            'output:${outputWidth}x$outputHeight'),
        outputWidth = outputWidth ?? device.screenSize.width,
        outputHeight = outputHeight ?? device.screenSize.height;

  final String category;
  final DeviceInfo device;
  final double outputWidth;
  final double outputHeight;
}

class _SimulatedNavBar extends StatelessWidget {
  const _SimulatedNavBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).padding.bottom == 0) {
      return child;
    }
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 0,
          height: MediaQuery.of(context).padding.bottom,
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              height: 4,
              width: 175,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const String _kDemoEmail =
    String.fromEnvironment('demoEmail', defaultValue: '');
const String _kDemoPassword =
    String.fromEnvironment('demoPassword', defaultValue: '');

Future<void> initializeAuth() async {
  assert(
    _kDemoEmail.isNotEmpty && _kDemoPassword.isNotEmpty,
    'You must specify the demo account\'s login info as environment variables '
    'to generate screenshots.',
  );
  if (AuthManager.instance.user?.email != _kDemoEmail) {
    if (AuthManager.instance.user != null) {
      await AuthManager.instance.signOut();
    }
    await AuthManager.instance.signInEmail(
      email: _kDemoEmail,
      // Password has a `!` in it but `!` escaping is broken in intellij's
      // command arguments configuration.
      password: '$_kDemoPassword!',
    );
  }
}

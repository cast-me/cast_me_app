import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/main.dart';
import 'package:cast_me_app/screenshot_template.dart';
import 'package:cast_me_app/widgets/common/update_message.dart';
import 'package:device_frame/device_frame.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test_driver/screenshots_test.dart';

const Locale en = Locale('en', '');

Future<void> main() async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> _initialize() async {
    UpdateMessage.disable();
    WidgetsApp.debugAllowBannerOverride = false;
    await initialize();
    await initializeAuth();
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
    CastDatabase.overrideWithMock(MockCastDatabase());
  }

  // Needs to be `late` because we can't call `_initialize` until we're in a
  // test function.
  late final Future<void> isInitialized = _initialize();

  setUp(() async {
    // must be run on every test.
    await binding.convertFlutterSurfaceToImage();
    return isInitialized;
  });

  tearDown(() {
    CastAudioPlayer.reset();
    CastMeBloc.reset();
    ListenBloc.reset();
    PostBloc.instance.reset();
  });

  for (final Locale locale in [
    en,
  ]) {
    for (final ScreenshotConfig config in [
      // ios.
      // https://help.apple.com/app-store-connect/#/devd274dd925
      ScreenshotConfig(
        category: '6.5',
        device: Devices.ios.iPhone13ProMax,
        outputWidth: 1284,
        outputHeight: 2778,
      ),
      ScreenshotConfig(
        category: '5.8',
        device: Devices.ios.iPhone13,
        outputWidth: 1170,
        outputHeight: 2532,
      ),
      ScreenshotConfig(
        category: '5.5',
        // Technically not the correct device but it's the same aspect ratio.
        device: Devices.ios.iPhoneSE,
        outputWidth: 1242,
        outputHeight: 2208,
      ),
      ScreenshotConfig(
        category: '12.9 gen2',
        device: Devices.ios.iPad12InchesGen2,
        outputHeight: 2732,
        outputWidth: 2048,
      ),
      ScreenshotConfig(
        category: '12.9 gen4',
        device: Devices.ios.iPad12InchesGen4,
        outputHeight: 2732,
        outputWidth: 2048,
      ),
      // Android.
      ScreenshotConfig(
        category: '',
        device: Devices.android.onePlus8Pro,
        outputHeight: 3168,
        outputWidth: 1440,
      ),
      ScreenshotConfig(
        category: '10',
        device: Devices.android.largeTablet,
      ),
      ScreenshotConfig(
        category: '7',
        device: Devices.android.mediumTablet,
      ),
    ]) {
      String screenshotName(String suffix) {
        return jsonEncode(
          ScreenshotIdentifier(
            path: [
              // ignore: prefer_interpolation_to_compose_strings
              config.device.identifier.platform.name,
              '${config.device.identifier.name} (${config.category})',
              locale.languageCode,
              suffix,
            ],
            width: config.outputWidth.toInt(),
            height: config.outputHeight.toInt(),
            offsetY: kTopPad.toInt(),
          ),
        );
      }

      void takeScreenshot(int i, String name, WidgetTesterCallback callback) {
        testWidgets(
          '($locale) (${config.device.name}) - $name.',
          (tester) async {
            await callback(tester);
            final String sanitizedName =
                name.toLowerCase().replaceAll(' ', '_');
            await tester.pumpFor(100);
            await binding.takeScreenshot(
              screenshotName('$i-$sanitizedName'),
            );
          },
        );
      }

      takeScreenshot(0, 'for_you', (WidgetTester tester) async {
        // English search page.
        await tester.pumpWidget(
          CastMeScreenshotTemplate(
            headerText: 'Listen to audio content personalized for you!',
            config: config,
            locale: locale,
          ),
        );
        await tester.pumpFor(100);
        await tester.pumpAndSettle();
      });

      takeScreenshot(1, 'explore', (WidgetTester tester) async {
        // English search page.
        await tester.pumpWidget(
          CastMeScreenshotTemplate(
            headerText: 'Explore the audio town square!',
            config: config,
            locale: locale,
          ),
        );
        await tester.pumpAndSettle();
        unawaited(ListenBloc.instance.onListenPageChanged(1));
        // Pump a little bit so pump and settle doesn't short circuit the page
        // change.
        await tester.pumpFor(100);
        await tester.pumpAndSettle();
      });

      takeScreenshot(2, 'post', (WidgetTester tester) async {
        // English search page.
        await tester.pumpWidget(
          CastMeScreenshotTemplate(
            headerText: 'Post your hot takes!',
            config: config,
            locale: locale,
          ),
        );
        await tester.pumpAndSettle();
        PostBloc.instance.titleText.value =
            'Why CastMe is going to disrupt the podcast market!';
        PostBloc.instance.overrideCastFile(
          CastFile(
            file: File('my_recording.mp4'),
            originalDuration: const Duration(milliseconds: 75537),
          ),
        );
        CastMeBloc.instance.onTabChanged(CastMeTab.post);
        // Pump a little bit so pump and settle doesn't short circuit the page
        // change.
        await tester.pumpFor(100);
        await tester.pumpAndSettle();
      });
    }
  }
}

extension ScreenshotUtils on WidgetTester {
  Future<void> pumpFor(
    int i, [
    Duration? duration,
    EnginePhase phase = EnginePhase.sendSemanticsUpdate,
  ]) async {
    for (int pumps = 0; pumps < i; pumps++) {
      await pump(duration);
    }
  }
}

class MockCastDatabase extends CastDatabase {
  late final Future<List<Conversation>> _handPickedConversations = Future.wait(
    [
      '9fecb8b7-d439-48e9-8cb8-a69e11264a88',
      '2d4f2984-64b4-4abc-a447-321d08815801',
      '219559bd-f42a-4473-925f-e2d64961d351',
      '44e5424d-d807-43fb-b5a9-caac8c42e0ca',
      '8331b763-8d83-46c9-874e-92f0b65daaac',
      'fe72a0f0-d1f7-452e-94e3-22ef20511c27',
      '8837dcd7-3ba3-4ab1-bbcd-b688d3712d9c',
    ].map((id) {
      return CastDatabase.instance.getConversation(id);
    }),
  );

  @override
  Stream<Conversation> getConversations({
    Profile? filterProfile,
    Profile? filterOutProfile,
    List<Topic>? filterTopics,
    // Only fetch conversations that have updates since last listen.
    bool onlyUpdates = false,
    int? limit,
  }) async* {
    yield* Stream.fromIterable(await _handPickedConversations);
  }
}

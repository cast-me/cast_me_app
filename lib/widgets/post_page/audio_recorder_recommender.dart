// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:launch_review/launch_review.dart';

class AudioRecorderRecommender extends StatelessWidget {
  const AudioRecorderRecommender({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () {
            LaunchReview.launch(
              iOSAppId: '1069512134',
              writeReview: false,
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Voice Memos',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ),
      );
    }
    if (Platform.isAndroid) {
      return Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () {
            LaunchReview.launch(
              androidAppId: 'com.zaza.beatbox',
              writeReview: false,
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Pro Audio Editor',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ),
      );
    }
    return Container();
  }
}

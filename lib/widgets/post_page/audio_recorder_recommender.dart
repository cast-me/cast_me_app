import 'dart:io';

import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

class AudioRecorderRecommender extends StatelessWidget {
  const AudioRecorderRecommender({Key? key}) : super(key: key);

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
            child: AdaptiveText(
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
            child: AdaptiveText(
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

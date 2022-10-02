import 'package:cast_me_app/business_logic/clients/audio_recorder.dart';

import 'package:flutter/material.dart';

import 'package:record/record.dart';

class RecordingBar extends StatelessWidget {
  const RecordingBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        height: 38,
        color: Colors.black,
        child: StreamBuilder<Amplitude>(
          stream: AudioRecorder.instance.amplitudes,
          builder: (context, snap) {
            if (!snap.hasData) {
              return Container();
            }
            return FractionallySizedBox(
              alignment: Alignment.centerLeft,
              // Max sound observed to be 0.
              // Quiet sounds are negative because reasons, and 80 seems
              // to be the negativist they get.
              widthFactor: ((80 + snap.data!.current) / 80).clamp(0, 1),
              child: Container(color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}
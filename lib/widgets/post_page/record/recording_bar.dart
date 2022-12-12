// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:record/record.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/audio_recorder.dart';

class RecordingBar extends StatefulWidget {
  const RecordingBar({super.key});

  @override
  State<RecordingBar> createState() => _RecordingBarState();
}

class _RecordingBarState extends State<RecordingBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(19),
      child: Container(
        height: 38,
        color: Colors.black,
        child: StreamBuilder<Amplitude>(
          stream: AudioRecorder.instance.amplitudes,
          builder: (context, snap) {
            if (!snap.hasData) {
              return Container();
            }
            return Stack(
              children: [
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  // Max sound observed to be 0.
                  // Quiet sounds are negative because reasons, and 80 seems
                  // to be the negativist they get.
                  widthFactor: ((80 + snap.data!.current) / 80).clamp(0, 1),
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (AudioRecorder
                        .instance.durationRecording.elapsedMilliseconds /
                        1000)
                        .toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

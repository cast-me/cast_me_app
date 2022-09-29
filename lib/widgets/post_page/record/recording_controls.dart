import 'package:cast_me_app/business_logic/clients/audio_recorder.dart';
import 'package:cast_me_app/widgets/post_page/record/record_button.dart';
import 'package:cast_me_app/widgets/post_page/record/recording_bar.dart';
import 'package:flutter/material.dart';

class RecordingControls extends StatelessWidget {
  const RecordingControls({
    Key? key,
    required this.recordingPath,
  }) : super(key: key);

  final ValueNotifier<String?> recordingPath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RecordButton(recordingPath: recordingPath),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 38,
              color: Colors.black,
              child: ValueListenableBuilder<bool>(
                  valueListenable: AudioRecorder.instance.isRecording,
                  builder: (context, isRecording, _) {
                    if (isRecording) {
                      return const RecordingBar();
                    }
                    return Container();
                  }),
            ),
          ),
        ),
      ],
    );
  }
}

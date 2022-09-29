import 'package:cast_me_app/business_logic/clients/audio_recorder.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:flutter/material.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({
    Key? key,
    required this.wrap,
  }) : super(key: key);

  final Wrapper wrap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
              (states) => Color.lerp(Colors.red, Colors.black, .1)!,
            ),
          ),
          child: ValueListenableBuilder<bool>(
            valueListenable: AudioRecorder.instance.isRecording,
            builder: (context, recording, _) {
              if (recording) {
                return const Icon(Icons.stop);
              }
              return const Icon(Icons.radio_button_on);
            },
          ),
          onPressed: () {
            wrap(
              'record',
              () async {
                if (!AudioRecorder.instance.isRecording.value) {
                  return AudioRecorder.instance.startRecording();
                }
                await AudioRecorder.instance.stopRecording();
                return;
              },
            );
          },
        ),
      ],
    );
  }
}

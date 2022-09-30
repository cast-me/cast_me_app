import 'package:cast_me_app/business_logic/clients/audio_recorder.dart';
import 'package:cast_me_app/business_logic/clients/clip_audio_player.dart';
import 'package:cast_me_app/business_logic/record_bloc.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AsyncActionWrapper wrapper = AsyncActionWrapper.of(context);
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
            wrapper.wrap(
              'record',
              () async {
                if (!AudioRecorder.instance.isRecording.value) {
                  return AudioRecorder.instance.startRecording(name: name);
                }
                RecordBloc.instance.recordingPath.value =
                    await AudioRecorder.instance.stopRecording();
                await ClipAudioPlayer.instance.setPath(
                  RecordBloc.instance.recordingPath.value!,
                );
                return;
              },
            );
          },
        ),
      ],
    );
  }

  String get name {
    final DateFormat formatter = DateFormat('yyyy_MM_dd_ssSSS');
    final DateTime now = DateTime.now();
    return 'recording'
        '_${formatter.format(now)}';
  }
}

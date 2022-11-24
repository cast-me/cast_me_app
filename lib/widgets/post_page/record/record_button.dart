// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/audio_recorder.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioRecorder recorder = AudioRecorder.instance;
    final AsyncActionWrapper wrapper = AsyncActionWrapper.of(context);
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
          (states) => Color.lerp(Colors.red, Colors.black, .1)!,
        ),
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: AudioRecorder.instance.isRecording,
        builder: (context, recording, _) {
          if (recording) {
            return const Text('Stop');
          }
          return const Text('record');
        },
      ),
      onPressed: () {
        wrapper.wrap(
          'record',
          () async {
            if (!AudioRecorder.instance.isRecording.value) {
              return PostBloc.instance.startRecording();
            }
            await PostBloc.instance.stopRecording();
            return;
          },
        );
      },
    );
  }
}

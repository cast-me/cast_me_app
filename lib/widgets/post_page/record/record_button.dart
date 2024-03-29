// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/audio_recorder.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
          (states) => Color.lerp(Colors.red, Colors.black, .1)!,
        ),
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: AudioRecorder.instance.isRecording,
        builder: (context, recording, _) {
          return ValueListenableBuilder<Future<CastFile>?>(
            valueListenable: PostBloc.instance.castFile,
            builder: (context, castFile, _) {
              if (recording) {
                return const Text('Stop');
              }
              if (PostBloc.instance.castFile.value != null) {
                return const Text('re-record');
              }
              return const Text('record');
            },
          );
        },
      ),
      onPressed: () async {
        if (!AudioRecorder.instance.isRecording.value) {
          return PostBloc.instance.startRecording();
        }
        PostBloc.instance.stopRecording();
        return;
      },
    );
  }
}

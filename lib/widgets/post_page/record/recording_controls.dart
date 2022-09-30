import 'package:cast_me_app/business_logic/clients/audio_recorder.dart';
import 'package:cast_me_app/business_logic/record_bloc.dart';
import 'package:cast_me_app/widgets/post_page/record/record_button.dart';
import 'package:cast_me_app/widgets/post_page/record/recording_bar.dart';
import 'package:flutter/material.dart';

class RecordingControls extends StatelessWidget {
  const RecordingControls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const RecordButton(),
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
                  return ValueListenableBuilder<String?>(
                    valueListenable: RecordBloc.instance.recordingPath,
                    builder: (context, path, _) {
                      if (path == null) {
                        return Container();
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Uri(path: path).pathSegments.last,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

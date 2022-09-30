import 'package:cast_me_app/business_logic/clients/audio_recorder.dart';
import 'package:cast_me_app/business_logic/clients/clip_audio_player.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/business_logic/record_bloc.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/widgets/listen_page/seek_bar.dart';
import 'package:cast_me_app/widgets/post_page/record/recording_controls.dart';
import 'package:cast_me_app/widgets/post_page/record/recording_playback_controls.dart';
import 'package:flutter/material.dart';

class RecordView extends StatelessWidget {
  const RecordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await showDialog<void>(
          context: context,
          builder: (context) {
            return AsyncActionWrapper(
              child: const RecordAudioModal(),
            );
          },
        );
      },
      child: const Text('Record'),
    );
  }
}

class RecordAudioModal extends StatefulWidget {
  const RecordAudioModal({
    Key? key,
  }) : super(key: key);

  @override
  State<RecordAudioModal> createState() => _RecordAudioModalState();
}

class _RecordAudioModalState extends State<RecordAudioModal> {
  @override
  Widget build(BuildContext context) {
    final ClipAudioPlayer player = ClipAudioPlayer.instance;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AdaptiveMaterial(
          adaptiveColor: AdaptiveColor.surface,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        if (AudioRecorder.instance.isRecording.value) {
                          AudioRecorder.instance.stopRecording();
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Record audio',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const RecordingControls(),
                SeekBar(
                  positionDataStream: player.positionDataStream,
                  seekTo: player.seekTo,
                ),
                const RecordingPlaybackControls(),
                ValueListenableBuilder<String?>(
                  valueListenable: RecordBloc.instance.recordingPath,
                  builder: (context, path, _) {
                    return ElevatedButton(
                      child: const Center(
                        child: Text('Submit'),
                      ),
                      onPressed: path == null
                          ? null
                          : () {
                              PostBloc.instance.onFilesSelected([path]);
                              RecordBloc.instance.recordingPath.value = null;
                              Navigator.of(context).pop();
                            },
                    );
                  },
                ),
                const AsyncErrorView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

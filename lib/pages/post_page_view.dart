// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/audio_recorder.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/widgets/common/async_submit_button.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/post_page/pick_file_view.dart';
import 'package:cast_me_app/widgets/post_page/post_help_tooltip.dart';
import 'package:cast_me_app/widgets/post_page/post_topic_selector.dart';
import 'package:cast_me_app/widgets/post_page/record/file_playback_controls.dart';
import 'package:cast_me_app/widgets/post_page/record/record_button.dart';
import 'package:cast_me_app/widgets/post_page/record/recording_bar.dart';
import 'package:cast_me_app/widgets/post_page/reply_cast_selector.dart';
import 'package:cast_me_app/widgets/post_page/title_field.dart';

class PostPageView extends StatefulWidget {
  const PostPageView({Key? key}) : super(key: key);

  @override
  State<PostPageView> createState() => _PostPageViewState();
}

class _PostPageViewState extends State<PostPageView> {
  final ValueNotifier<String> titleText = ValueNotifier('');
  final CastListController castListController = CastListController();

  Key titleFieldKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return AsyncActionWrapper(
      child: CastMePage(
        headerText: 'Post',
        scrollable: true,
        child: ValueListenableBuilder<CastFile?>(
          valueListenable: PostBloc.instance.castFile,
          builder: (context, castFile, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: const [
                    PostHelpTooltip(),
                    SizedBox(width: 4),
                    AdaptiveText('Cast audio:'),
                  ],
                ),
                Container(
                  child: Row(
                    children: [
                      const Expanded(child: RecordButton()),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: AudioRecorder.instance.isRecording,
                          builder: (context, isRecording, child) {
                            if (!isRecording) {
                              return child!;
                            }
                            return const RecordingBar();
                          },
                          child: const PickFileView(),
                        ),
                      ),
                    ],
                  ),
                ),
                _SelectedAudioView(castFile: castFile),
                const FileAudioPlayerControls(),
                const AsyncErrorView(),
                const ReplyCastSelector(),
                const SizedBox(height: 8),
                const Text('Cast title'),
                TitleField(key: titleFieldKey, titleText: titleText),
                const SizedBox(height: 8),
                const PostTopicSelector(),
                ValueListenableBuilder<String>(
                  valueListenable: titleText,
                  builder: (context, title, _) {
                    final ScaffoldMessengerState messenger =
                        ScaffoldMessenger.of(context);
                    return AsyncSubmitButton(
                      child: const Text('Submit'),
                      onPressed: castFile != null && title.isNotEmpty
                          ? () async {
                              await PostBloc.instance.submitFile(
                                title: title,
                                castFile: castFile,
                              );
                              setState(() {
                                titleText.value = '';
                                // Gross hack to force the title field to
                                // rebuild from scratch.
                                titleFieldKey = UniqueKey();
                              });
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Cast posted!'),
                                ),
                              );
                            }
                          : null,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SelectedAudioView extends StatelessWidget {
  const _SelectedAudioView({
    Key? key,
    required this.castFile,
  }) : super(key: key);

  final CastFile? castFile;

  @override
  Widget build(BuildContext context) {
    if (castFile == null) {
      return Container();
    }
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            PostBloc.instance.clearFiles();
          },
        ),
        Expanded(
          child: Text(castFile!.name),
        ),
      ],
    );
  }
}

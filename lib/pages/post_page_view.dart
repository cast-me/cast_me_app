// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/audio_recorder.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/post_page/external_link_field.dart';
import 'package:cast_me_app/widgets/post_page/pick_file_view.dart';
import 'package:cast_me_app/widgets/post_page/post_help_tooltip.dart';
import 'package:cast_me_app/widgets/post_page/post_topic_selector.dart';
import 'package:cast_me_app/widgets/post_page/record/file_playback_controls.dart';
import 'package:cast_me_app/widgets/post_page/record/record_button.dart';
import 'package:cast_me_app/widgets/post_page/record/recording_bar.dart';
import 'package:cast_me_app/widgets/post_page/reply_cast_selector.dart';
import 'package:cast_me_app/widgets/post_page/submit_cast_button.dart';
import 'package:cast_me_app/widgets/post_page/title_field.dart';

class PostPageView extends StatefulWidget {
  const PostPageView({Key? key}) : super(key: key);

  @override
  State<PostPageView> createState() => _PostPageViewState();
}

class _PostPageViewState extends State<PostPageView> {
  final CastMeListController<Cast> castListController = CastMeListController();

  @override
  void dispose() {
    if (AudioRecorder.instance.isRecording.value) {
      // Ensure we save our recording before we exit the page.
      PostBloc.instance.stopRecording();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncActionWrapper(
      child: CastMePage(
        headerText: 'Post',
        scrollable: true,
        child: ValueListenableBuilder<Future<CastFile>?>(
          valueListenable: PostBloc.instance.castFile,
          builder: (context, fileFuture, _) {
            return _SubmitFormField(fileFuture: fileFuture);
          },
        ),
        footer: SubmitCastButton(
          reset: () {
            setState(() {
              PostBloc.instance.reset();
            });
          },
        ),
      ),
    );
  }
}

class _SubmitFormField extends StatelessWidget {
  const _SubmitFormField({
    Key? key,
    required this.fileFuture,
  }) : super(key: key);

  final Future<CastFile>? fileFuture;

  @override
  Widget build(BuildContext context) {
    final PostBloc bloc = PostBloc.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const ReplyCastSelector(),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '2. Audio',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(width: 4),
            const PostHelpTooltip(),
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
        if (fileFuture != null)
          FutureBuilder<CastFile>(
            future: fileFuture,
            builder: (context, snap) {
              if (snap.hasError) {
                return ErrorText(error: snap.error!);
              }
              if (!snap.hasData) {
                return Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4,
                  ),
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SelectedAudioView(castFile: snap.data!),
                  FileAudioPlayerControls(castFile: snap.data!),
                ],
              );
            },
          ),
        const SizedBox(height: 4),
        Text(
          '3. Details',
          style: Theme.of(context).textTheme.headline5,
        ),
        TitleField(key: bloc.titleFieldKey, titleText: bloc.titleText),
        ExternalLinkField(
          controller: bloc.externalLinkTextController,
        ),
        const SizedBox(height: 8),
        const PostTopicSelector(),
        const AsyncErrorView(),
      ],
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

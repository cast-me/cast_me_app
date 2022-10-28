// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:just_the_tooltip/just_the_tooltip.dart';

// Project imports:
import 'package:cast_me_app/widgets/post_page/audio_recorder_recommender.dart';

class PostHelpTooltip extends StatelessWidget {
  const PostHelpTooltip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      isModal: true,
      triggerMode: TooltipTriggerMode.tap,
      child: const Icon(Icons.help),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Options for recording/uploading audio:\n'
                'A) Use an external recording app and use the share button to '
                'share with CastMe\n'
                'B) Use the record button below and record a clip in-app\n'
                'C) Select an existing audio file\n'
                '\n'
                'Recommended external recording app:'),
            AudioRecorderRecommender(),
          ],
        ),
      ),
    );
  }
}

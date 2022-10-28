// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:just_audio/just_audio.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/util/collection_utils.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';

class TrackListView extends StatelessWidget {
  const TrackListView({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<IndexedAudioSource>>(
      valueListenable: CastAudioPlayer.instance.queue,
      builder: (context, queue, _) {
        return CastViewTheme(
          indentReplies: false,
          showLikes: false,
          dimIfListened: false,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: queue
                .map<Widget>(
                  (source) {
                    return CastPreview(
                      cast: source.cast,
                      padding: EdgeInsets.zero,
                      isInTrackList: true,
                    );
                  },
                )
                .separated(const SizedBox(height: 8))
                .toList(),
          ),
        );
      },
    );
  }
}

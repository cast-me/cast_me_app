import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/widgets/cast_view.dart';

import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';

class TrackListView extends StatelessWidget {
  const TrackListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<IndexedAudioSource>>(
        valueListenable: CastAudioPlayer.instance.queue,
        builder: (context, queue, _) {
          return ListView(
            padding: EdgeInsets.zero,
            children: queue
                .map(
                  (source) => CastPreview(
                    cast: source.cast,
                    padding: EdgeInsets.zero,
                  ),
                )
                .toList(),
          );
        });
  }
}

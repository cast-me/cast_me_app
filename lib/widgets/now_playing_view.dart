import 'package:cast_me_app/models/cast.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/cast_view.dart';
import 'package:flutter/material.dart';

class NowPlayingView extends StatefulWidget {
  const NowPlayingView({Key? key, required this.cast}) : super(key: key);

  final Cast cast;

  @override
  State<NowPlayingView> createState() => _NowPlayingViewState();
}

class _NowPlayingViewState extends State<NowPlayingView> {
  Duration progressDuration = const Duration(seconds: 100);

  double get progress =>
      progressDuration.inMilliseconds / widget.cast.duration.inMilliseconds;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: CastPreview(cast: widget.cast)),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.pause),
              color: AdaptiveMaterial.onColorOf(context),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.skip_next),
              color: AdaptiveMaterial.onColorOf(context),
            ),
          ],
        ),
        LinearProgressIndicator(
          minHeight: 1,
          value: progress,
          color: AdaptiveMaterial.onColorOf(context),
          backgroundColor: AdaptiveMaterial.onColorOf(context)!.withAlpha(150),
        ),
      ],
    );
  }
}

import 'package:cast_me_app/bloc/cast_me_bloc.dart';
import 'package:cast_me_app/bloc/models/cast.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/cast_view.dart';

import 'package:flutter/material.dart';

class NowPlayingView extends StatefulWidget {
  const NowPlayingView({Key? key}) : super(key: key);

  @override
  State<NowPlayingView> createState() => _NowPlayingViewState();
}

class _NowPlayingViewState extends State<NowPlayingView> {
  Duration? progressDuration = const Duration(seconds: 100);

  final ListenBloc model = CastMeBloc.instance.listenModel;

  double get progress =>
      progressDuration!.inMilliseconds /
      model.currentCast.value!.duration.inMilliseconds;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Cast?>(
        valueListenable: model.currentCast,
        builder: (context, cast, _) {
          if (cast == null) {
            return Container();
          }
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CastPreview(cast: cast),
                  ),
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
                color: cast.accentColor ?? AdaptiveMaterial.onColorOf(context)!,
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
            ],
          );
        });
  }
}

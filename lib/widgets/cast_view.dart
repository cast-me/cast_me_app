import 'package:cast_me_app/bloc/cast_me_bloc.dart';
import 'package:cast_me_app/bloc/models/cast.dart';
import 'package:cast_me_app/widgets/listen_page/now_playing_view.dart';

import 'package:flutter/material.dart';

class CastPreview extends StatelessWidget {
  const CastPreview({
    required this.cast,
    Key? key,
  }) : super(key: key);

  final Cast cast;

  @override
  Widget build(BuildContext context) {
    final bool isInNowPlaying =
        context.findAncestorWidgetOfExactType<NowPlayingView>() != null;
    return InkWell(
      onTap: () {
        CastMeBloc.instance.listenModel.onCastChanged(cast);
      },
      child: ValueListenableBuilder<Cast?>(
          valueListenable: CastMeBloc.instance.listenModel.currentCast,
          builder: (context, nowPlaying, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: !isInNowPlaying && nowPlaying == cast
                    ? Theme.of(context).colorScheme.surface
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(cast.imagePath)),
                        ),
                        child: !isInNowPlaying && nowPlaying == cast
                            ? Container(
                                color: (cast.accentColor ?? Colors.black)
                                    .withAlpha(120),
                                child: const Icon(Icons.bar_chart, size: 30),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cast.title,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            DefaultTextStyle(
                              style: TextStyle(color: Colors.grey.shade400),
                              child: Row(
                                children: [
                                  Text(cast.author),
                                  const Text(' - '),
                                  Text(cast.duration.toFormattedString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

extension FormattedDuration on Duration {
  String toFormattedString() {
    return '${inMinutes.toString()}:'
        '${(inSeconds ~/ 60 * inMinutes).toString().padLeft(2, '0')}';
  }
}

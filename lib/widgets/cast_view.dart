import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/widgets/listen_page/now_playing_view.dart';
import 'package:firebase_image/firebase_image.dart';

import 'package:flutter/material.dart';

class CastPreview extends StatelessWidget {
  const CastPreview({
    Key? key,
    required this.cast,
  }) : super(key: key);

  final Cast cast;

  @override
  Widget build(BuildContext context) {
    final bool isInNowPlaying =
        context.findAncestorWidgetOfExactType<NowPlayingView>() != null;
    return CastProvider(
      cast: cast,
      child: InkWell(
        // Only enable the inkwell if this isn't already the currently playing
        // cast.
        onTap: isInNowPlaying
            ? null
            : () {
                CastMeBloc.instance.listenBloc.onCastChanged(cast);
              },
        child: ValueListenableBuilder<Cast?>(
          valueListenable: ListenBloc.instance.currentCast,
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
                            image: FirebaseImage(cast.imageUriBase),
                          ),
                        ),
                        child: !isInNowPlaying && nowPlaying == cast
                            ? Container(
                                color: (cast.accentColor).withAlpha(120),
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
                              child: const _AuthorLine(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CastView extends StatelessWidget {
  const CastView({Key? key, required this.cast}) : super(key: key);

  final Cast cast;

  @override
  Widget build(BuildContext context) {
    return CastProvider(
      cast: cast,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Image(
              image: FirebaseImage(cast.imageUriBase),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cast.title,
            style: const TextStyle(color: Colors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          DefaultTextStyle(
            style: TextStyle(color: Colors.grey.shade400),
            child: const _AuthorLine(),
          ),
        ],
      ),
    );
  }
}

extension FormattedDuration on Duration {
  String toFormattedString() {
    return '${inMinutes.toString()}:'
        '${(inSeconds % 60).toString().padLeft(2, '0')}';
  }
}

class _AuthorLine extends StatelessWidget {
  const _AuthorLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cast cast = CastProvider.of(context);
    return DefaultTextStyle(
      style: TextStyle(color: Colors.grey.shade400),
      child: Text(
        '${cast.author} - ${cast.duration.toFormattedString()}',
      ),
    );
  }
}

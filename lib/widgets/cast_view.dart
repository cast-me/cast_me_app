import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:firebase_image/firebase_image.dart';

import 'package:flutter/material.dart';

class CastPreview extends StatelessWidget {
  const CastPreview({
    Key? key,
    required this.cast,
    this.padding,
    this.fullyInteractive = true,
  }) : super(key: key);

  final Cast cast;

  final EdgeInsets? padding;

  /// Whether or not to make this an inkwell and display a shading if it's the
  /// currently playing cast.
  final bool fullyInteractive;

  @override
  Widget build(BuildContext context) {
    return CastProvider(
      cast: cast,
      child: ValueListenableBuilder<Cast?>(
        valueListenable: ListenBloc.instance.currentCast,
        builder: (context, nowPlaying, _) {
          return InkWell(
            // Only enable the inkwell if this isn't already the currently
            // playing cast.
            onTap: fullyInteractive && cast != nowPlaying
                ? () {
                    CastMeBloc.instance.listenBloc.onCastChanged(cast);
                  }
                : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: padding ?? const EdgeInsets.all(8),
                color: fullyInteractive && nowPlaying == cast
                    ? Colors.white.withAlpha(80)
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
                            image: FirebaseImage(cast.imageUrl),
                          ),
                        ),
                        child: fullyInteractive && nowPlaying == cast
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
                            AdaptiveText(
                              cast.title,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 1,
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
            ),
          );
        },
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
              loadingBuilder: (context, _, __) =>
                  const CircularProgressIndicator(color: Colors.white),
              image: FirebaseImage(cast.imageUrl),
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
        '${cast.authorDisplayName} - ${cast.duration.toFormattedString()}',
      ),
    );
  }
}

import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/common/drop_down_menu.dart';

import 'package:flutter/material.dart';

class CastPreview extends StatelessWidget {
  const CastPreview({
    Key? key,
    required this.cast,
    this.padding,
    this.fullyInteractive = true,
    this.showMenu = true,
    this.showHowOld = true,
    this.isInTrackList = false,
  }) : super(key: key);

  final Cast cast;

  final EdgeInsets? padding;

  /// Whether or not to make this an inkwell and display a shading if it's the
  /// currently playing cast.
  final bool fullyInteractive;

  final bool showMenu;

  final bool showHowOld;

  final bool isInTrackList;

  @override
  Widget build(BuildContext context) {
    return CastProvider(
      cast: cast,
      child: ValueListenableBuilder<Cast?>(
        valueListenable: ListenBloc.instance.currentCast,
        builder: (context, nowPlaying, _) {
          return Opacity(
            opacity: cast.hasViewed && cast != nowPlaying ? .4 : 1,
            child: InkWell(
              // Only enable the inkwell if this isn't already the currently
              // playing cast.
              onTap: fullyInteractive && cast != nowPlaying
                  ? () {
                      if (isInTrackList) {
                        return ListenBloc.instance
                            .onCastInTrackListSelected(cast);
                      }
                      ListenBloc.instance.onCastChanged(cast);
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
                              image: NetworkImage(cast.imageUrl),
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
                              Row(
                                children: [
                                  if (showHowOld)
                                    Text(
                                      '${_oldString(cast.createdAt)} - ',
                                      style: TextStyle(
                                          color: Colors.grey.shade400),
                                    ),
                                  const _ListenCount(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (showMenu) const _CastMenu(),
                    ],
                  ),
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
              image: NetworkImage(cast.imageUrl),
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

class _CastMenu extends StatelessWidget {
  const _CastMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch these here because we don't have a valid `context` from an
    // onPressed callback.
    final CastListViewState? castListView = CastListView.of(context);
    final Cast cast = CastProvider.of(context);
    return DropDownWidget(
      builder: (context, hideMenu) {
        return Column(
          children: [
            TextButton(
              onPressed: () async {
                hideMenu();
                await CastDatabase.instance.deleteCast(cast: cast);
                castListView?.refresh();
              },
              child: Row(
                children: const [
                  Text('delete cast'),
                  Icon(Icons.delete),
                ],
              ),
            ),
          ],
        );
      },
      child: const Icon(Icons.more_vert),
    );
  }
}

extension FormattedDuration on Duration {
  String toFormattedString() {
    return '${inMinutes.toString()}:'
        '${(inSeconds % 60).toString().padLeft(2, '0')}';
  }
}

class _ListenCount extends StatelessWidget {
  const _ListenCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cast cast = CastProvider.of(context);
    return Text(
      '${cast.viewCount} listen${cast.viewCount == 1 ? '' : 's'}',
      style: TextStyle(color: Colors.grey.shade400),
    );
  }
}

class _AuthorLine extends StatelessWidget {
  const _AuthorLine({
    Key? key,
  }) : super(key: key);

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

String _oldString(DateTime createdAt) {
  final Duration howOld = DateTime.now().difference(createdAt);
  if (howOld.inDays > 31) {
    return '${createdAt.month}/${createdAt.day}';
  }
  if (howOld.inHours > 24) {
    return '${howOld.inDays}d';
  }
  if (howOld.inMinutes > 60) {
    return '${howOld.inHours}h';
  }
  if (howOld.inSeconds > 60) {
    return '${howOld.inMinutes}m';
  }
  return 'just now';
}

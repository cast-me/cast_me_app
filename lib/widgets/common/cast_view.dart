import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/util/collection_utils.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/common/drop_down_menu.dart';
import 'package:cast_me_app/widgets/listen_page/now_playing_view.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            opacity: cast.authorId != AuthManager.instance.profile.id &&
                    cast.hasViewed &&
                    cast != nowPlaying
                ? .4
                : 1,
            child: InkWell(
              // Only enable the inkwell if this isn't already the currently
              // playing cast.
              onTap: fullyInteractive && cast != nowPlaying
                  ? () {
                      if (isInTrackList) {
                        return ListenBloc.instance
                            .onCastInTrackListSelected(cast);
                      }
                      ListenBloc.instance.onCastSelected(cast);
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
                              fit: BoxFit.cover,
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
                              const _CastTitleView(),
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
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(cast.imageUrl),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const _CastTitleView(),
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
    final CastListController? castListViewController =
        CastListController.of(context);
    final Cast cast = CastProvider.of(context);
    if (AuthManager.instance.profile.id != cast.authorId) {
      return Container();
    }
    return DropDownMenu(
      builder: (context, hideMenu) {
        return Column(
          children: [
            TextButton(
              onPressed: () async {
                hideMenu();
                await CastDatabase.instance.deleteCast(cast: cast);
                castListViewController?.refresh();
              },
              child: Row(
                children: const [
                  AdaptiveText('delete cast'),
                  AdaptiveIcon(Icons.delete),
                ],
              ),
            ),
          ],
        );
      },
      adaptiveBackgroundColor: AdaptiveColor.background,
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

class _CastTitleView extends StatelessWidget {
  const _CastTitleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cast cast = CastProvider.of(context);
    // Only make it tappable if we're not in the now playing view.
    final bool tappable =
        context.findAncestorWidgetOfExactType<NowPlayingView>() == null;
    return Text.rich(
      _constructSpan(cast.title, cast.taggedUsernames, tappable),
      style: const TextStyle(color: Colors.white),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Parse the title into a list of spans where valid usernames are underlined
  // and everything else is normal.
  TextSpan _constructSpan(
    String title,
    List<String> taggedUsernames,
    bool tappable,
  ) {
    if (taggedUsernames.isEmpty) {
      return TextSpan(text: title);
    }
    // Code golf! :D
    // Try to improve, I'm sure there's lots of low hanging fruit on mine.
    // This is also a brittle poor readability nightmare, maybe consider giving
    // up on code golf and making it readable instead.
    int i = 0;
    return TextSpan(
      children: [
        ...(taggedUsernames
                .expand((username) => '@$username'.allMatches(title))
                .toList()
              ..sortBy((m) => m.start))
            .expand((m) {
          final List<TextSpan> spans = [
            if (m.start > i) TextSpan(text: title.substring(i, m.start)),
            // Underline the username.
            TextSpan(
              text: title.substring(m.start, m.end),
              style: const TextStyle(decoration: TextDecoration.underline),
              recognizer: tappable
                  ? (TapGestureRecognizer()
                    ..onTap = () {
                      // Add 1 to snip the `@` from the start.
                      CastMeBloc.instance.onUsernameSelected(
                          title.substring(m.start + 1, m.end));
                    })
                  : null,
            ),
          ];
          i = m.end;
          return spans;
        }),
        if (i < title.length) TextSpan(text: title.substring(i)),
      ],
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
    return DateFormat('MMM d').format(createdAt);
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

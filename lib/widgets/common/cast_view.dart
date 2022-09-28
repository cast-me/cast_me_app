import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/util/collection_utils.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/common/drop_down_menu.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class CastPreview extends StatelessWidget {
  const CastPreview({
    Key? key,
    required this.cast,
    this.padding,
    this.showHowOld = true,
    this.isInTrackList = false,
  }) : super(key: key);

  final Cast cast;

  final EdgeInsets? padding;

  final bool showHowOld;

  final bool isInTrackList;

  @override
  Widget build(BuildContext context) {
    final CastViewTheme? theme = CastViewTheme.of(context);
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
            child: Row(
              children: [
                if ((theme?.indentReplies ?? true) && cast.replyTo.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      color: Colors.white.withAlpha(120),
                      width: 2,
                      height: 66,
                    ),
                  ),
                Expanded(
                  child: InkWell(
                    onTap: _getOnTap(context, nowPlaying),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: padding ?? const EdgeInsets.all(8),
                        color: _isTapToPlay(context) && nowPlaying == cast
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
                                child: _isTapToPlay(context) &&
                                        nowPlaying == cast
                                    ? Container(
                                        color:
                                            (cast.accentColor).withAlpha(120),
                                        child: const Icon(Icons.bar_chart,
                                            size: 30),
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
                                      style: TextStyle(
                                          color: Colors.grey.shade400),
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
                            if (theme?.showMenu ?? true) const _CastMenu(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _playOnTap() {
    if (isInTrackList) {
      return ListenBloc.instance.onCastInTrackListSelected(cast);
    }
    ListenBloc.instance.onCastSelected(cast);
  }

  VoidCallback? _getOnTap(
    BuildContext context,
    Cast? nowPlaying,
  ) {
    final void Function(Cast)? themeOnTap = CastViewTheme.of(context)?.onTap;
    if (themeOnTap != null) {
      return () => themeOnTap(cast);
    }
    if (CastViewTheme.of(context)?.isInteractive == false) {
      return null;
    }
    if (_isTapToPlay(context) && cast != nowPlaying) {
      return _playOnTap;
    }
    return null;
  }

  // If `onTap` isn't overwritten, then this is a basic now-playing cast.
  bool _isTapToPlay(BuildContext context) =>
      CastViewTheme.of(context)?.isInteractive != false &&
      CastViewTheme.of(context)?.onTap == null;
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
    final CastViewTheme? theme = CastViewTheme.of(context);
    return DropDownMenu(
      builder: (context, hideMenu) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MenuButton(
              icon: Icons.reply,
              text: 'reply',
              onTap: () async {
                PostBloc.instance.replyCast.value = cast;
                CastMeBloc.instance.onTabChanged(CastMeTab.post);
              },
            ),
            if (!(theme?.hideDelete ?? true))
              _MenuButton(
                icon: Icons.delete,
                text: 'delete cast',
                onTap: () async {
                  hideMenu();
                  await CastDatabase.instance.deleteCast(cast: cast);
                  castListViewController?.refresh();
                },
              ),
          ],
        );
      },
      adaptiveBackgroundColor: AdaptiveColor.background,
      child: const Icon(Icons.more_vert),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final AsyncCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Row(
        children: [
          AdaptiveIcon(icon),
          const SizedBox(width: 4),
          AdaptiveText(text),
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
    // TODO(caseycrogers): get rid of this sloppy garbage and replace it with a
    //   a `CastViewTheme` inherited widget.
    final bool tappable =
        CastViewTheme.of(context)?.taggedUsersAreTappable ?? true;
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

class ReplyCastView extends StatelessWidget {
  const ReplyCastView({
    Key? key,
    required this.replyCast,
  }) : super(key: key);

  final Cast replyCast;
  static const double _size = 12;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        const Icon(Icons.keyboard_return, size: _size),
        Container(
          height: _size,
          width: _size,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(replyCast.imageUrl),
            ),
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Text(
            replyCast.title,
            style: const TextStyle(fontSize: _size),
          ),
        ),
      ],
    );
  }
}

class CastViewTheme extends InheritedWidget {
  const CastViewTheme({
    Key? key,
    required Widget child,
    this.showMenu,
    this.taggedUsersAreTappable,
    this.isInteractive,
    this.hideDelete,
    this.onTap,
    this.indentReplies,
  })  : assert((isInteractive ?? true) || onTap == null),
        super(key: key, child: child);

  final bool? showMenu;
  final bool? taggedUsersAreTappable;
  final bool? isInteractive;
  final bool? hideDelete;
  final bool? indentReplies;
  final void Function(Cast)? onTap;

  static CastViewTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CastViewTheme>();
  }

  @override
  bool updateShouldNotify(CastViewTheme oldWidget) {
    return showMenu != oldWidget.showMenu ||
        taggedUsersAreTappable != oldWidget.taggedUsersAreTappable ||
        isInteractive != oldWidget.isInteractive ||
        onTap != oldWidget.onTap;
  }
}

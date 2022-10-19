import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:cast_me_app/widgets/common/cast_menu.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/common/drop_down_menu.dart';
import 'package:cast_me_app/widgets/common/likes_view.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

/// TODO(caseycrogers): do a pass over this class to clean it up and break out
///   logic into sub-widgets.
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

  bool shouldDim(BuildContext context) {
    if (!(CastViewTheme.of(context)?.dimIfListened ?? true)) {
      return false;
    }
    if (cast == ListenBloc.instance.currentCast.value) {
      return false;
    }
    if (cast.authorId == AuthManager.instance.profile.id) {
      return true;
    }
    return cast.hasViewed;
  }

  @override
  Widget build(BuildContext context) {
    final CastViewTheme? theme = CastViewTheme.of(context);
    return CastProvider(
      cast: cast,
      child: ValueListenableBuilder<Cast?>(
        valueListenable: ListenBloc.instance.currentCast,
        builder: (context, nowPlaying, _) {
          return Row(
            children: [
              if ((theme?.indentReplies ?? true) && cast.replyTo.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    color: Colors.white.withAlpha(120),
                    width: 2,
                    // TODO(caseycrogers): make this programmatic.
                    height: theme?.showLikes ?? true ? 89 : 63,
                  ),
                ),
              Expanded(
                child: InkWell(
                  onTap: _getOnTap(context, nowPlaying),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: padding ?? const EdgeInsets.all(4),
                      color: _isTapToPlay(context) && nowPlaying == cast
                          ? Colors.white.withAlpha(80)
                          : null,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Opacity(
                                  opacity: shouldDim(context) ? .6 : 1,
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
                                              image: CachedNetworkImageProvider(
                                                  cast.imageUrl),
                                            ),
                                          ),
                                          child: _isTapToPlay(context) &&
                                                  nowPlaying == cast
                                              ? Container(
                                                  color: (cast.accentColor)
                                                      .withAlpha(120),
                                                  child: const Icon(
                                                      Icons.bar_chart,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const _CastTitleView(),
                                              DefaultTextStyle(
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade400),
                                                child: const _AuthorLine(),
                                              ),
                                              Row(
                                                children: [
                                                  if (showHowOld)
                                                    Text(
                                                      '${_oldString(cast.createdAt)} - ',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade400),
                                                    ),
                                                  const _ListenCount(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (theme?.showLikes ?? true) const LikesView(),
                              ],
                            ),
                          ),
                          if (theme?.showMenu ?? true) const CastMenu(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                image: CachedNetworkImageProvider(cast.imageUrl),
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
    //   `CastViewTheme` inherited widget.
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
              image: CachedNetworkImageProvider(replyCast.imageUrl),
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

/// Controls various stylings and functions of `CastPreview`.
///
/// All boolean flags default to true. Cast previews reference only the nearest
/// enclosing cast view theme-themes do not inherit from each other.
class CastViewTheme extends InheritedWidget {
  const CastViewTheme(
      {Key? key,
      required Widget child,
      this.showMenu,
      this.taggedUsersAreTappable,
      this.isInteractive,
      this.showLikes,
      this.onTap,
      this.indentReplies,
      this.dimIfListened})
      : super(key: key, child: child);

  /// Whether or not to show the three dots menu.
  final bool? showMenu;

  /// Whether or not tapping on a tagged user will take you to their profile.
  final bool? taggedUsersAreTappable;

  /// Whether or not tapping on the cast triggers a callback.
  ///
  /// See [onTap].
  final bool? isInteractive;

  /// Whether or not to show the like icon below the cast.
  final bool? showLikes;

  /// Whether or not to visually indent replies.
  final bool? indentReplies;

  /// Whether or not to dim the cast to indicate that it's been listened.
  ///
  /// For the purposes of dimming, self-authored casts are considered to have
  /// already been viewed.
  final bool? dimIfListened;

  /// The callback to be called when the cast is tapped on.
  ///
  /// By default `CastAudioPlayer.play(cast)` is called.
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

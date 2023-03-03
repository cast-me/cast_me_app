// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:boxy/flex.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/widgets/common/cast_menu.dart';
import 'package:cast_me_app/widgets/common/external_link_button.dart';
import 'package:cast_me_app/widgets/common/hide_if_deleted.dart';
import 'package:cast_me_app/widgets/common/likes_view.dart';
import 'package:cast_me_app/widgets/common/text_with_tappable_usernames.dart';
import 'package:cast_me_app/widgets/common/uri_button.dart';
import 'package:cast_me_app/widgets/listen_page/conversation_view.dart';
import 'package:cast_me_app/widgets/profile_page/default_picture.dart';

/// TODO(caseycrogers): do a pass over this class to clean it up and break out
///   logic into sub-widgets.
class CastPreview extends StatelessWidget {
  const CastPreview({
    super.key,
    required this.cast,
    this.padding,
    this.showHowOld = true,
    this.isInTrackList = false,
  });

  final Cast cast;

  final EdgeInsets? padding;

  final bool showHowOld;

  final bool isInTrackList;

  bool shouldIndicateNew(BuildContext context) {
    if (CastViewTheme.of(context)?.indicateNew == false) {
      return false;
    }
    if (cast == ListenBloc.instance.currentCast.value) {
      return false;
    }
    if (cast.authorId == AuthManager.instance.profile.id) {
      return false;
    }
    return !cast.hasViewed;
  }

  Color overlayColor(BuildContext context) => Color.lerp(
        Colors.white,
        Theme.of(context).colorScheme.surface,
        .92,
      )!;

  @override
  Widget build(BuildContext context) {
    final CastViewTheme? theme = CastViewTheme.of(context);
    // TODO(caseycrogers): break this into more readable sub widgets.
    return CastProvider(
      initialCast: cast,
      child: ValueListenableBuilder<Cast?>(
        valueListenable: ListenBloc.instance.currentCast,
        builder: (context, nowPlaying, _) {
          return HideIfDeleted(
            isDeleted: cast.deleted,
            child: InkWell(
              onTap: _getOnTap(context, nowPlaying),
              child: IndicateViewed(
                isUnread: shouldIndicateNew(context),
                child: Container(
                  padding: EdgeInsets.only(
                    left: padding?.left ?? 4,
                    right: padding?.right ?? 4,
                  ),
                  color: _isTapToPlay(context) && nowPlaying == cast
                      ? overlayColor(context)
                      : null,
                  child: BoxyRow(
                    children: [
                      if ((theme?.indentReplies ?? true) &&
                          cast.replyTo != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            color: Colors.white.withAlpha(120),
                            width: 2,
                            // TODO(caseycrogers): make this programmatic.
                            height: theme?.showLikes ?? true ? 89 : 63,
                          ),
                        ),
                      Dominant.expanded(
                        child: StackCastMenu(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Put the title here if we're showing the menu or
                              // showing how old.
                              // Else put it below in the row.
                              if ((theme?.showMenu ?? true) || showHowOld)
                                const _CastTitleView(),
                              if (cast.externalUri != null)
                                UriButton(uri: cast.externalUri!),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PreviewThumbnail(
                                    imageUrl: cast.imageUrl,
                                    displayName: cast.authorDisplayName,
                                    size: 50,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (!(theme?.showMenu ?? true) &&
                                            !showHowOld)
                                          const _CastTitleView(),
                                        const AuthorLine(),
                                        const _ListenCount(),
                                        if (showHowOld)
                                          HowOldLine(
                                            createdAt: cast.createdAtStamp,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (theme?.showLikes ?? true) const LikesView(),
                            ],
                          ),
                        ),
                      ),
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

  Future<void> _playOnTap() async {
    if (isInTrackList) {
      await ListenBloc.instance.onCastInTrackListSelected(cast);
      return;
    }
    await ListenBloc.instance.onCastSelected(cast);
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
}

class IndicateViewed extends StatelessWidget {
  const IndicateViewed({
    super.key,
    required this.isUnread,
    required this.child,
  });

  final bool isUnread;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!isUnread) {
      return child;
    }
    return Stack(
      children: [
        const Positioned(
          top: 10,
          right: 10,
          width: 10,
          height: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

// If `onTap` isn't overwritten, then this is a basic now-playing cast.
bool _isTapToPlay(BuildContext context) =>
    CastViewTheme.of(context)?.isInteractive != false &&
    CastViewTheme.of(context)?.onTap == null;

class CastView extends StatelessWidget {
  const CastView({super.key, required this.cast});

  final Cast cast;

  @override
  Widget build(BuildContext context) {
    return CastProvider(
      initialCast: cast,
      child: Column(
        children: [
          const Spacer(),
          CastMenu(
            wide: true,
            onTap: () {
              // Ensure the now playing sheet gets closed.
              ListenBloc.instance.sheetController.animateTo(
                0,
                duration: const Duration(milliseconds: 50),
                curve: Curves.linear,
              );
            },
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: cast.imageUrl != null
                        ? BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: CachedNetworkImageProvider(cast.imageUrl!),
                            ),
                          )
                        : null,
                    child: cast.imageUrl == null
                        ? DefaultPicture(
                            padding: EdgeInsets.zero,
                            displayName: cast.authorDisplayName,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
          if (cast.externalUri != null)
            Align(
              child: ExternalLinkButton(uri: cast.externalUri!),
              alignment: Alignment.centerLeft,
            )
          else
            const SizedBox(height: 8),
          const _CastTitleView(textAlign: TextAlign.center),
          DefaultTextStyle(
            style: TextStyle(color: Colors.grey.shade400),
            child: const AuthorLine(),
          ),
          const LikesView(),
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
  const _ListenCount();

  @override
  Widget build(BuildContext context) {
    final Cast cast = CastProvider.of(context).value;
    return Text(
      '${cast.viewCount} listen${cast.viewCount == 1 ? '' : 's'}',
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AdaptiveMaterial.secondaryOnColorOf(context),
          ),
    );
  }
}

class _CastTitleView extends StatelessWidget {
  const _CastTitleView({this.textAlign});

  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final Cast cast = CastProvider.of(context).value;
    final CastViewTheme? theme = CastViewTheme.of(context);
    final bool tappable = theme?.taggedUsersAreTappable ?? true;
    if (!tappable) {
      return Text(
        cast.title,
        textAlign: textAlign,
        style: const TextStyle(color: Colors.white),
        maxLines: theme?.titleMaxLines,
        overflow: theme?.titleMaxLines != null ? TextOverflow.ellipsis : null,
      );
    }
    return TappableUsernameText(
      cast.title,
      textAlign: textAlign,
      style: const TextStyle(color: Colors.white),
      maxLines: theme?.titleMaxLines,
      overflow: theme?.titleMaxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}

class AuthorLine extends StatelessWidget {
  const AuthorLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Cast cast = CastProvider.of(context).value;
    return Text(
      '${cast.authorDisplayName} - ${cast.duration.toFormattedString()}',
    );
  }
}

class HowOldLine extends StatelessWidget {
  const HowOldLine({
    super.key,
    required this.createdAt,
  });

  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    return Text(
      oldString(),
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AdaptiveMaterial.secondaryOnColorOf(context),
          ),
    );
  }

  String oldString() {
    final Duration howOld = DateTime.now().difference(createdAt);
    if (howOld.inDays > 6) {
      return DateFormat('MMM d').format(createdAt);
    }
    if (howOld.inHours > 24) {
      return '${howOld.inDays}d ago';
    }
    if (howOld.inMinutes > 60) {
      return '${howOld.inHours}h ago';
    }
    if (howOld.inSeconds > 60) {
      return '${howOld.inMinutes}m ago';
    }
    return 'just now';
  }
}

class PreviewThumbnail extends StatelessWidget {
  const PreviewThumbnail({
    super.key,
    required this.imageUrl,
    required this.displayName,
    this.size,
  });

  final String? imageUrl;
  final String displayName;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: imageUrl != null
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider(imageUrl!),
                    ),
                  ),
                )
              : DefaultPicture(displayName: displayName),
        ),
      ),
    );
  }
}

/// Controls various stylings and functions of `CastPreview`.
///
/// All boolean flags default to true. Cast previews reference only the nearest
/// enclosing cast view theme-themes do not inherit from each other.
class CastViewTheme extends InheritedWidget {
  const CastViewTheme({
    super.key,
    required super.child,
    this.showMenu,
    this.taggedUsersAreTappable,
    this.isInteractive,
    this.showLikes,
    this.onTap,
    this.indentReplies,
    this.indicateNew,
    this.showLink,
    this.titleMaxLines,
    this.imageLinkTapEnabled,
  });

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

  /// Whether or not to show a UI element indicating that a cast is new.
  ///
  /// Self-authored casts are not considered new.
  final bool? indicateNew;

  /// Whether or not to show a link button if the cast has an external link.
  final bool? showLink;

  /// How many lines of text the title should be truncated to-unlimited if null.
  final int? titleMaxLines;

  /// Whether or not clicking on the cast's image should take the user to the
  /// cast's associated link, if non-null.
  final bool? imageLinkTapEnabled;

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

class CastConversationView extends StatelessWidget {
  const CastConversationView({super.key});

  @override
  Widget build(BuildContext context) {
    final Cast rootCast = CastProvider.of(context).value;
    final Conversation conversation = ConversationProvider.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AdaptiveMaterial.secondaryOnColorOf(context),
              ),
          child: BoxyRow(
            children: [
              PreviewThumbnail(
                imageUrl: rootCast.imageUrl,
                displayName: rootCast.authorDisplayName,
              ),
              const SizedBox(width: 4),
              Dominant(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rootCast.authorDisplayName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text('@${rootCast.authorUsername}'),
                    Text(
                      _topicsToString(conversation.topics),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          rootCast.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  String _topicsToString(List<String>? topics) {
    if (topics == null) {
      return '';
    }
    return '${topics.map((t) => '#$t').join(' ')}';
  }
}

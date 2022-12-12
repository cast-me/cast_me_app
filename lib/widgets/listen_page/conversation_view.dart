// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/hide_if_deleted.dart';
import 'package:cast_me_app/widgets/common/uri_button.dart';

class ConversationPreview extends StatelessWidget {
  const ConversationPreview({
    super.key,
    required this.conversation,
    this.margin,
    this.padding,
  });

  final Conversation conversation;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final Cast rootCast = conversation.rootCast;
    return InkWell(
      onTap: () {
        ListenBloc.instance.onConversationSelected(conversation);
      },
      child: ConversationProvider(
        conversation: conversation,
        child: CastProvider(
          initialCast: rootCast,
          child: Container(
            margin: margin ?? const EdgeInsets.all(4),
            padding: padding ?? const EdgeInsets.all(4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HideIfDeleted(
                  isDeleted: rootCast.deleted,
                  child: const CastConversationView(),
                ),
                const SizedBox(height: 4),
                if (rootCast.externalUri != null)
                  UriButton(uri: rootCast.externalUri!),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: AdaptiveMaterial.secondaryOnColorOf(context),
                      ),
                  child: Row(
                    children: [
                      Text(_repliesString(conversation.castCount)),
                      const Text(' - '),
                      const NewCount(),
                      const Text(' - '),
                      Text(_likesString(conversation.likeCount)),
                      const Text(' - '),
                      HowOldLine(createdAt: rootCast.createdAtStamp),
                    ],
                  ),
                ),
                const PlayConversationButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _repliesString(int length) {
    if (length == 1) {
      return '1 cast';
    }
    return '$length casts';
  }

  String _likesString(int count) {
    if (count == 1) {
      return '1 like';
    }
    return '$count likes';
  }
}

class NewCount extends StatelessWidget {
  const NewCount({super.key});

  @override
  Widget build(BuildContext context) {
    final Conversation conversation = ConversationProvider.of(context);
    return Text(
      '${conversation.newCastCount} new',
      style: conversation.newCastCount != 0
          ? Theme.of(context).textTheme.bodyText1
          : null,
    );
  }
}

class ConversationProvider extends InheritedWidget {
  const ConversationProvider({
    super.key,
    required super.child,
    required this.conversation,
  });

  final Conversation conversation;

  static Conversation of(BuildContext context) {
    final ConversationProvider? result =
        context.dependOnInheritedWidgetOfExactType<ConversationProvider>();
    assert(result != null, 'No ConversationProvider found in context');
    return result!.conversation;
  }

  @override
  bool updateShouldNotify(ConversationProvider oldWidget) {
    return oldWidget.conversation != conversation;
  }
}

class PlayConversationButton extends StatelessWidget {
  const PlayConversationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final Conversation conversation = ConversationProvider.of(context);
    final bool isReplay = !conversation.hasNewCasts;
    return ElevatedButtonTheme(
      data: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(const StadiumBorder()),
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          ListenBloc.instance.playConversation(
            conversation,
            skipViewed: !isReplay,
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isReplay ? Icons.skip_previous : Icons.play_arrow),
            const SizedBox(width: 4),
            Text(
              _durationString(
                isReplay
                    ? conversation.contentLength
                    : conversation.newContentLength,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _durationString(Duration duration) {
    if (duration.inMinutes <= 1) {
      return '1 min';
    }
    return '${duration.inMinutes} mins';
  }
}

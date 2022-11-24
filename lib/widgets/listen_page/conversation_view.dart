import 'package:adaptive_material/adaptive_material.dart';
import 'package:boxy/flex.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/uri_button.dart';
import 'package:flutter/material.dart';

class ConversationPreview extends StatelessWidget {
  const ConversationPreview({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  final Conversation conversation;

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
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: AdaptiveMaterial.secondaryOnColorOf(context),
                      ),
                  child: BoxyRow(
                    children: [
                      PreviewThumbnail(cast: rootCast),
                      const SizedBox(width: 4),
                      Dominant(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rootCast.authorDisplayName,
                              style: Theme.of(context).textTheme.bodyText2,
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
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 4),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (rootCast.externalUri != null)
                      UriButton(uri: rootCast.externalUri!),
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: AdaptiveMaterial.secondaryOnColorOf(context),
                          ),
                      child: Row(
                        children: [
                          Text(_repliesString(conversation.allCasts.length)),
                          const Text(' - '),
                          const NewCount(),
                          const Text(' - '),
                          HowOldLine(createdAt: rootCast.createdAtStamp),
                        ],
                      ),
                    ),
                    Row(
                      children: const [
                        PlayConversationButton(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _topicsToString(List<String>? topics) {
    if (topics == null) {
      return '';
    }
    return '${topics.map((t) => '#$t').join(' ')}';
  }

  String _repliesString(int length) {
    if (length == 0) {
      return '1 cast';
    }
    return '$length casts';
  }
}

class NewCount extends StatelessWidget {
  const NewCount({Key? key}) : super(key: key);

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
  const PlayConversationButton({Key? key}) : super(key: key);

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

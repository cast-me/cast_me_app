// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:rxdart/rxdart.dart';

class ConversationPageView extends StatelessWidget {
  const ConversationPageView({
    super.key,
    required this.selectedConversation,
  });

  final SelectedConversation selectedConversation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Conversation>(
      // We don't need to wrap this in a value listenable builder because
      // the cast list view will handle fetching internally.
      future: selectedConversation.conversation.value,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        final Conversation conversation = snap.data!;
        return CastMePage(
          scrollable: false,
          padding: EdgeInsets.zero,
          child: _LoadedPageContent(conversation: conversation),
        );
      },
    );
  }
}

class _LoadedPageContent extends StatefulWidget {
  const _LoadedPageContent({
    required this.conversation,
  });

  final Conversation conversation;

  @override
  State<_LoadedPageContent> createState() => _LoadedPageContentState();
}

class _LoadedPageContentState extends State<_LoadedPageContent> {
  late final CastMeListController<Cast> controller = CastMeListController(
    getStream: (_) => Stream.fromIterable(widget.conversation.allCasts),
  );

  @override
  Widget build(BuildContext context) {
    return CastViewTheme(
      onTap: (cast) {
        ListenBloc.instance.playConversation(
          widget.conversation,
          startAtCast: cast,
          // If we're starting at a specific cast, assume that we want to
          // listen to everything.
          skipViewed: false,
        );
      },
      child: CastListView(
        padding: EdgeInsets.zero,
        controller: CastMeListController<Cast>(
          // TODO(caseycrogers): This is really messy, considering migrating
          // `getStream` to just a `stream` and an `onRefresh` callback.
          getStream: (_) {
            return ListenBloc.instance.selectedConversation.value!
                .refresh()
                .asStream()
                .flatMap(
              (_) {
                return ListenBloc
                    .instance.selectedConversation.value!.conversation.value
                    .asStream()
                    .flatMap((c) => Stream.fromIterable(c.allCasts));
              },
            );
          },
        ),
      ),
    );
  }
}

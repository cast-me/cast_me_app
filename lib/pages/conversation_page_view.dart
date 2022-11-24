// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';

class ConversationPageView extends StatelessWidget {
  const ConversationPageView({
    Key? key,
    required this.selectedConversation,
  }) : super(key: key);

  final SelectedConversation selectedConversation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Conversation?>(
      future: selectedConversation.conversation,
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
          headerText: conversation.rootCast.title,
          padding: EdgeInsets.zero,
          child: CastViewTheme(
            onTap: (cast) {
              ListenBloc.instance.playConversation(
                conversation,
                startAtCast: cast,
                // If we're starting at a specific cast, assume that we want to
                // listen to everything.
                skipViewed: false,
              );
            },
            child: CastListView(
              padding: EdgeInsets.zero,
              getCasts: () => Stream.fromIterable(conversation.allCasts),
            ),
          ),
        );
      },
    );
  }
}

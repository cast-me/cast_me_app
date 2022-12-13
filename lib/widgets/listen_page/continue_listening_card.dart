import 'package:cast_me_app/business_logic/for_you_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/widgets/common/horizontal_card_list.dart';
import 'package:cast_me_app/widgets/listen_page/conversation_view.dart';
import 'package:flutter/material.dart';

class ContinueListeningCard extends StatelessWidget {
  const ContinueListeningCard({
    super.key,
    this.pagePadding,
  });

  final EdgeInsets? pagePadding;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Future<List<Conversation>>>(
      valueListenable: ForYouBloc.instance.continueListeningConversations,
      builder: (context, conversations, child) {
        return FutureBuilder<List<Conversation>>(
          future: conversations,
          builder: (context, snap) {
            if (snap.hasError) {
              return ErrorText(error: snap.error!);
            }
            if (!snap.hasData || snap.data!.isEmpty) {
              return Container();
            }
            return HorizontalCardList(
              padding: pagePadding,
              headerText: 'Continue listening',
              pages: snap.data!.map(
                (c) {
                  return ConversationPreview(
                    conversation: c,
                    margin: EdgeInsets.zero,
                  );
                },
              ).toList(),
            );
          },
        );
      }
    );
  }
}

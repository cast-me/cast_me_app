import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/widgets/common/horizontal_card_list.dart';
import 'package:cast_me_app/widgets/listen_page/conversation_view.dart';
import 'package:flutter/material.dart';

class CatchUpCard extends StatefulWidget {
  const CatchUpCard({
    super.key,
    this.pagePadding,
  });

  final EdgeInsets? pagePadding;

  @override
  State<CatchUpCard> createState() => _CatchUpCardState();
}

class _CatchUpCardState extends State<CatchUpCard> {
  final Future<List<Conversation>> conversations = CastDatabase.instance
      .getConversations(
        limit: 10,
        onlyUpdates: true,
      )
      .toList();

  @override
  Widget build(BuildContext context) {
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
          padding: widget.pagePadding,
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
}

import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:flutter/material.dart';

class ConversationPageView extends StatelessWidget {
  const ConversationPageView({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return CastMePage(
      scrollable: false,
      headerText: conversation.rootCast.title,
      padding: EdgeInsets.zero,
      child: CastListView(
        padding: EdgeInsets.zero,
        getCasts: () => Stream.fromIterable(conversation.allCasts),
      ),
    );
  }
}

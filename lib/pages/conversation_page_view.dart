import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/listen_page/conversation_view.dart';
import 'package:flutter/material.dart';

class ConversationPageView extends StatelessWidget {
  const ConversationPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Conversation conversation = ConversationProvider.of(context);
    return CastListView(
      getCasts: () => Stream.fromIterable(conversation.allCasts),
    );
  }
}

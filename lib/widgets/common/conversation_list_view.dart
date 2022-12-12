// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:cast_me_app/widgets/listen_page/conversation_view.dart';

class ConversationListView extends StatelessWidget {
  const ConversationListView({
    super.key,
    this.filterTopics,
    this.padding,
    this.controller,
  });

  /// If non-null, restrict conversations to the given topic.
  final List<Topic>? filterTopics;

  final EdgeInsets? padding;

  final CastMeListController<Conversation>? controller;

  @override
  Widget build(BuildContext context) {
    return CastMeListView<Conversation>(
      controller: controller,
      builder: (context, conversations, index) {
        return ConversationPreview(conversation: conversations[index]);
      },
    );
  }
}

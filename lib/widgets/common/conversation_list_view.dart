// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';

class ConversationListView extends StatelessWidget {
  const ConversationListView({
    Key? key,
    this.filterTopics,
    this.padding,
    this.controller,
  }) : super(key: key);

  /// If non-null, restrict conversations to the given topic.
  final List<Topic>? filterTopics;

  final EdgeInsets? padding;

  final CastMeListController<Conversation>? controller;

  @override
  Widget build(BuildContext context) {
    return CastMeListView<Conversation>(
      controller: controller,
      getStream: () => CastDatabase.instance
          .getConversations(
        filterTopics: filterTopics,
      )
          .handleError(
        (Object error) {
          if (kDebugMode) {
            print(error);
          }
        },
      ),
      builder: (context, conversations, index) {
        return CastPreview(
          padding: const EdgeInsets.only(
            top: 4,
            bottom: 2,
            left: 12,
            right: 12,
          ),
          cast: conversations[index].rootCast,
        );
      },
    );
  }
}

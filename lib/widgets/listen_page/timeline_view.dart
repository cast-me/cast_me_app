// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/conversation_list_view.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Topic>>(
      valueListenable: ListenBloc.instance.filteredTopics,
      builder: (context, filteredTopics, _) {
        return CastViewTheme(
          child: ConversationListView(
            padding: const EdgeInsets.only(bottom: 8),
            controller: ListenBloc.instance.timelineListController,
            filterTopics: filteredTopics.isEmpty ? null : filteredTopics,
          ),
        );
      },
    );
  }
}

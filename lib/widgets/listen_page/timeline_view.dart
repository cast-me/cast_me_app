// Flutter imports:
import 'package:cast_me_app/widgets/listen_page/topics_view.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/conversation_list_view.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopicSelector(
          interiorPadding: const EdgeInsets.symmetric(horizontal: 4),
          controller: ListenBloc.instance.timelineListController,
          onTap: ListenBloc.instance.onTopicToggled,
        ),
        Expanded(
          child: CastViewTheme(
            child: ConversationListView(
              padding: const EdgeInsets.only(bottom: 8),
              controller: ListenBloc.instance.timelineListController,
            ),
          ),
        ),
      ],
    );
  }
}

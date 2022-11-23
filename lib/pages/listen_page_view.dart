// Flutter imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:cast_me_app/business_logic/models/serializable/conversation.dart';
import 'package:cast_me_app/pages/conversation_page_view.dart';
import 'package:cast_me_app/widgets/listen_page/timeline_view.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:cast_me_app/widgets/listen_page/topics_view.dart';
import 'package:implicit_navigator/implicit_navigator.dart';

class ListenPageView extends StatefulWidget {
  const ListenPageView({Key? key}) : super(key: key);

  @override
  State<ListenPageView> createState() => _ListenPageViewState();
}

class _ListenPageViewState extends State<ListenPageView> {
  final TopicsViewController topicsController = TopicsViewController();

  @override
  void initState() {
    if (ListenBloc.instance.currentCast.value == null) {
      CastDatabase.instance.getSeedCast().then((cast) {
        // Seed the now playing cast with content on app launch.
        // Check a second time just in case the user has selected a cast while
        // we were getting the seed cast.
        if (cast != null && ListenBloc.instance.currentCast.value == null) {
          ListenBloc.instance.onCastSelected(cast, autoPlay: false);
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ImplicitNavigator.fromValueListenable<Conversation?>(
      key: const PageStorageKey('selected_conversation_key'),
      maintainHistory: true,
      valueListenable: ListenBloc.instance.selectedConversation,
      onPop: (poppedValue, valueAfterPop) {
        ListenBloc.instance.onConversationSelected(valueAfterPop);
      },
      getDepth: (conversation) => conversation == null ? 0 : 1,
      transitionsBuilder: transition,
      builder: (context, conversation, animation, secondaryAnimation) {
        if (conversation != null) {
          return ConversationPageView(conversation: conversation);
        }
        return AdaptiveMaterial.background(
          child: SafeArea(
            bottom: false,
            child: NotificationListener<
                CastMeListRefreshNotification<Conversation>>(
              onNotification: (_) {
                topicsController.refresh();
                return false;
              },
              child: Column(
                children: [
                  TopicSelector(
                    interiorPadding: const EdgeInsets.symmetric(horizontal: 8),
                    controller: topicsController,
                    selectedTopics: ListenBloc.instance.filteredTopics,
                    onTap: ListenBloc.instance.onTopicToggled,
                  ),
                  const Expanded(
                    child: TimelineView(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget transition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    ) {
  return SlideTransition(
    position: Tween(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(animation),
    child: SlideTransition(
      position: Tween(
        begin: Offset.zero,
        end: const Offset(-.5, 0),
      ).animate(secondaryAnimation),
      child: child,
    ),
  );
}


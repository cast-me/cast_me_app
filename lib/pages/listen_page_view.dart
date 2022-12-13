// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:implicit_navigator/implicit_navigator.dart';

// Project imports:
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/pages/conversation_page_view.dart';
import 'package:cast_me_app/widgets/listen_page/listen_sub_pages.dart';

class ListenPageView extends StatelessWidget {
  const ListenPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ImplicitNavigator.fromValueListenable<SelectedConversation?>(
      key: const PageStorageKey('selected_conversation_key'),
      maintainHistory: true,
      valueListenable: ListenBloc.instance.selectedConversation,
      onPop: (poppedValue, valueAfterPop) {
        ListenBloc.instance.onConversationIdSelected(
          valueAfterPop?.id,
          conversation: valueAfterPop?.conversation.value,
        );
      },
      getDepth: (selection) => selection == null ? 0 : 1,
      transitionsBuilder: transition,
      transitionDuration: const Duration(milliseconds: 100),
      builder: (context, selectedConversation, animation, secondaryAnimation) {
        if (selectedConversation != null) {
          return ConversationPageView(
            selectedConversation: selectedConversation,
          );
        }
        return const AdaptiveMaterial.background(
          child: SafeArea(
            bottom: false,
            child: ListenSubPages(),
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

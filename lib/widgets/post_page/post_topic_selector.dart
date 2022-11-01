// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/widgets/listen_page/topics_view.dart';

class PostTopicSelector extends StatelessWidget {
  const PostTopicSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostBloc bloc = PostBloc.instance;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Topics (max 3, can\'t be used if \'reply to\' is set):'),
        const SizedBox(height: 8),
        ValueListenableBuilder<Cast?>(
          valueListenable: bloc.replyCast,
          builder: (context, cast, child) {
            // You can't specify topics if this is a reply cast.
            return IgnorePointer(
              ignoring: cast != null,
              child: Opacity(
                opacity: cast == null ? 1 : .5,
                child: child!,
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AdaptiveMaterial(
              adaptiveColor: AdaptiveColor.background,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TopicsView(
                  currentTopics: bloc.topics,
                  onTap: (topic) {
                    if (bloc.topics.value.length == 3) {
                      // Only allow a max of 3 topics.
                      return;
                    }
                    bloc.topics.toggle(topic);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

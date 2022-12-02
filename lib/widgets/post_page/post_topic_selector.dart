// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/widgets/listen_page/topics_view.dart';

class PostTopicSelector extends StatelessWidget {
  const PostTopicSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostBloc bloc = PostBloc.instance;
    return TopicViewTheme(
      data: const TopicThemeData(
        showNewCastsCount: false,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TopicSelector(
                controller: TopicSelectorController(),
                max: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

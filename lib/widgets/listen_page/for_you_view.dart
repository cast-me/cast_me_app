// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/for_you_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/widgets/common/external_link_button.dart';
import 'package:cast_me_app/widgets/common/update_message.dart';
import 'package:cast_me_app/widgets/listen_page/continue_listening_card.dart';
import 'package:cast_me_app/widgets/listen_page/follow_up_card.dart';
import 'package:cast_me_app/widgets/listen_page/trend_card.dart';

const EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 12);

class ForYouView extends StatelessWidget {
  const ForYouView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        await ForYouBloc.instance.onRefresh();
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: const [
          Padding(
            padding: _padding,
            child: _TrendingView(),
          ),
          ContinueListeningCard(pagePadding: _padding),
          FollowUpCard(padding: _padding),
          Padding(
            padding: _padding,
            child: _DiscordView(),
          ),
        ],
      ),
    );
  }
}

class _TrendingView extends StatelessWidget {
  const _TrendingView();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Future<List<Topic>>>(
      valueListenable: ForYouBloc.instance.trending,
      builder: (context, trending, child) {
        return FutureBuilder<List<Topic>>(
          future: trending,
          builder: (context, snap) {
            if (snap.hasError) {
              return ErrorWidget(snap.error!);
            }
            if (!snap.hasData) {
              return Container();
            }
            final List<Topic> topics =
                snap.data!.where((t) => true || t.newCastCount != 0).toList();
            if (topics.isEmpty) {
              return Container();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: topics
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TrendCard(topic: c),
                    ),
                  )
                  .toList(),
            );
          },
        );
      },
    );
  }
}

class _DiscordView extends StatelessWidget {
  const _DiscordView();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Join our discord to chat with the developers and other '
              'power users!',
            ),
            ExternalLinkButton(uri: discordUrl),
          ],
        ),
      ),
    );
  }
}

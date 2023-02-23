// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/for_you_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/widgets/common/external_link_button.dart';
import 'package:cast_me_app/widgets/common/update_message.dart';
import 'package:cast_me_app/widgets/listen_page/continue_listening_card.dart';
import 'package:cast_me_app/widgets/listen_page/follow_up_card.dart';
import 'package:cast_me_app/widgets/listen_page/play_new_card.dart';

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
            child: PlayNowView(),
          ),
          CuratedConversationsCard(pagePadding: _padding),
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

class PlayNowView extends StatelessWidget {
  const PlayNowView();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Future<Cast?>>(
      valueListenable: ForYouBloc.instance.seedCast,
      builder: (context, seedCast, child) {
        return FutureBuilder<Cast?>(
          future: seedCast,
          builder: (context, snap) {
            if (snap.hasError) {
              return ErrorWidget(snap.error!);
            }
            if (!snap.hasData) {
              return const Text(
                'There are no new casts at the moment. To kickstart the '
                'conversation post a new cast or ask a friend to join in!',
                textAlign: TextAlign.center,
              );
            }
            return PlayNewCard(seedCast: snap.data!);
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

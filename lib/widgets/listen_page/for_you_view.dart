// Flutter imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/widgets/common/external_link_button.dart';
import 'package:cast_me_app/widgets/common/update_message.dart';
import 'package:cast_me_app/widgets/listen_page/catch_up_card.dart';
import 'package:cast_me_app/widgets/listen_page/share_card.dart';
import 'package:cast_me_app/widgets/listen_page/trend_card.dart';
import 'package:flutter/material.dart';

const EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 12);

class ForYouView extends StatelessWidget {
  const ForYouView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Padding(
          padding: _padding,
          child: _TrendingView(),
        ),
        CatchUpCard(
          pagePadding: _padding,
        ),
        ShareCard(
          pagePadding: _padding,
        ),
        Padding(
          padding: _padding,
          child: _DiscordView(),
        ),
      ],
    );
  }
}

class _TrendingView extends StatefulWidget {
  const _TrendingView();

  @override
  State<_TrendingView> createState() => _TrendingViewState();
}

class _TrendingViewState extends State<_TrendingView> {
  // TODO(caseycrogers): make `ForYou` it's own class instead of just using
  //   topic.
  Future<List<Topic>> cardsFuture = _getCards();

  static Future<List<Topic>> _getCards() async {
    return CastDatabase.instance.getForYouCards();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
      future: cardsFuture,
      builder: (context, snap) {
        if (snap.hasError) {
          return ErrorWidget(snap.error!);
        }
        if (!snap.hasData) {
          return Container();
        }
        final List<Topic> topics =
            snap.data!.where((t) => t.newCastCount != 0).toList();
        if (topics.isEmpty) {
          return const Text(
            'No new content, try recording a new cast!',
            textAlign: TextAlign.center,
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
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
  }
}

class _DiscordView extends StatelessWidget {
  const _DiscordView();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AdaptiveMaterialType.surface.colorOf(context),
      margin: EdgeInsets.zero,
      child: AdaptiveMaterial(
        material: AdaptiveMaterialType.surface,
        shouldDraw: false,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Icon(Icons.discord),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Join our discord to chat with the developers and other '
                      'power users!',
                    ),
                  ),
                ],
              ),
              ExternalLinkButton(uri: discordUrl),
            ],
          ),
        ),
      ),
    );
  }
}

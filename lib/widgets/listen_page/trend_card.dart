// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';

class TrendCard extends StatelessWidget {
  const TrendCard({
    super.key,
    required this.topic,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await ListenBloc.instance.onForYouSelected(topic);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '#',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(width: 2),
              Text(
                topic.name,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
          Text(
            '${topic.castCount} casts - ${topic.likeCount} likes',
          ),
        ],
      ),
    );
  }
}

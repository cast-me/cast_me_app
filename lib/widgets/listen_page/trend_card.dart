import 'package:boxy/flex.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:flutter/material.dart';

class TrendCard extends StatelessWidget {
  const TrendCard({
    super.key,
    required this.topic,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: BoxyRow(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Icon(
              Icons.play_arrow,
              size: constraints.maxHeight,
              color: Colors.white,
            );
          }),
          const SizedBox(width: 4),
          Dominant(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  topic.name,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.white),
                ),
                Text(
                  '${topic.castCount} casts - ${topic.likeCount} likes',
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () async {
        await ListenBloc.instance.onForYouSelected(topic);
      },
    );
  }
}

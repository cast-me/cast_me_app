// Flutter imports:
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';

class TopicsView extends StatefulWidget {
  const TopicsView({
    Key? key,
    required this.currentTopics,
    required this.onTap,
    this.max,
  }) : super(key: key);

  final ValueListenable<List<Topic>> currentTopics;
  final void Function(Topic) onTap;
  final int? max;

  @override
  State<TopicsView> createState() => _TopicsViewState();
}

class _TopicsViewState extends State<TopicsView> {
  final Future<List<Topic>> allTopics = CastDatabase.instance.getAllTopics();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
      future: allTopics,
      builder: (context, snap) {
        if (snap.hasError) {
          return Text(
            snap.error.toString(),
            style: TextStyle(color: Theme.of(context).errorColor),
          );
        }
        if (!snap.hasData) {
          return Container();
        }
        return ValueListenableBuilder<List<Topic>>(
          valueListenable: widget.currentTopics,
          builder: (context, selectedTopics, _) {
            final numTopics = selectedTopics.length;
            return Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: snap.data!.map((topic) {
                  return TopicChip(
                    key: ValueKey<Topic>(topic),
                    topic: topic,
                    isSelected: selectedTopics.contains(topic),
                    isEnabled: widget.max == null || numTopics < widget.max!,
                    onTap: () => widget.onTap(topic),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}

class TopicChip extends StatelessWidget {
  const TopicChip({
    Key? key,
    required this.topic,
    required this.isSelected,
    required this.onTap,
    this.isEnabled = true,
  }) : super(key: key);

  final Topic topic;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final Color color =
        AdaptiveMaterial.adaptiveColorOf(context) == AdaptiveColor.background
            ? AdaptiveColor.surface.color(context)
            : AdaptiveColor.background.color(context);
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: FilterChip(
          label: Text.rich(
            TextSpan(
              text: '#${topic.name}',
              children: [
                TextSpan(
                  text: ' ${topic.castCount}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          backgroundColor: color,
          selectedColor: color,
          side: BorderSide(
            width: 1,
            color: isSelected ? Colors.white : Colors.transparent,
          ),
          selected: isSelected,
          onSelected: isSelected || isEnabled ? (_) => onTap() : null,
        ),
      ),
    );
  }
}

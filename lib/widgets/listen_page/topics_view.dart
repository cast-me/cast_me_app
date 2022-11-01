// Flutter imports:
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
  }) : super(key: key);

  final ValueListenable<List<Topic>> currentTopics;
  final void Function(Topic) onTap;

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
            return Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: snap.data!.map((topic) {
                  return TopicChip(
                    key: ValueKey<Topic>(topic),
                    topic: topic,
                    isSelected: selectedTopics.contains(topic),
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
  }) : super(key: key);

  final Topic topic;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedColor: Colors.transparent,
          side: BorderSide(
            width: 1,
            color: isSelected ? Colors.white : Colors.transparent,
          ),
          selected: isSelected,
          onSelected: (_) => onTap(),
        ),
      ),
    );
  }
}

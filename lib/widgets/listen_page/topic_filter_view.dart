import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:flutter/material.dart';

class TopicFilterView extends StatefulWidget {
  const TopicFilterView({Key? key}) : super(key: key);

  @override
  State<TopicFilterView> createState() => _TopicFilterViewState();
}

class _TopicFilterViewState extends State<TopicFilterView> {
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
            valueListenable: ListenBloc.instance.filteredTopics,
            builder: (context, filteredTopics, _) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  children: snap.data!.map((topic) {
                    return TopicChip(
                      key: ValueKey<Topic>(topic),
                      topic: topic,
                      isSelected: filteredTopics.contains(topic),
                      onTap: () => ListenBloc.instance.onTopicToggled(topic),
                    );
                  }).toList(),
                ),
              );
            });
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: FilterChip(
        label: Text('#${topic.name}'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedColor: Colors.transparent,
        side: BorderSide(
          width: 1,
          color: isSelected ? Colors.white : Colors.transparent,
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

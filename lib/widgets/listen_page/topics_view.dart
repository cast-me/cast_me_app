// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/util/collection_utils.dart';
import 'package:cast_me_app/util/listenable_utils.dart';

class TopicSelector extends StatefulWidget {
  const TopicSelector({
    super.key,
    required this.controller,
    this.interiorPadding,
    this.max,
  });

  final EdgeInsets? interiorPadding;
  final TopicSelectorController controller;
  final int? max;

  @override
  State<TopicSelector> createState() => _TopicSelectorState();
}

class _TopicSelectorState extends State<TopicSelector> {
  Future<List<Topic>> allTopics = _getTopics();

  static Future<List<Topic>> _getTopics() async {
    return CastDatabase.instance.getTopics();
  }

  void _onRefresh() {
    setState(() {
      allTopics = _getTopics();
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onRefresh);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onRefresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
      future: allTopics,
      builder: (context, snap) {
        if (snap.hasError) {
          return Text(
            snap.error.toString(),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          );
        }
        if (!snap.hasData) {
          return Container();
        }
        final List<Topic> topics = snap.data!;
        return ValueListenableBuilder<List<Topic>>(
          // We get the actual topic objects from all topics as it has fresh
          // view and cast counts.
          valueListenable: widget.controller.select((c) {
            return c.filterTopics
                .map((f) => topics.singleWhere((t) => f.id == t.id))
                .toList();
          }),
          builder: (context, selectedTopics, _) {
            final numTopics = selectedTopics.length;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TopicsView(
                  topics: topics
                      .sortedBy((t) => -t.newCastCount)
                      .where((t) => !selectedTopics.any((s) => s.id == t.id))
                      .toList(),
                  onTap: (topic) {
                    widget.controller.toggle(topic);
                  },
                  isSelected: (_) => false,
                  isEnabled: widget.max == null || numTopics < widget.max!,
                  interiorPadding: widget.interiorPadding,
                  scrollable: true,
                ),
                TopicsView(
                  topics: selectedTopics,
                  onTap: (topic) {
                    widget.controller.toggle(topic);
                  },
                  isSelected: (_) => true,
                  interiorPadding: widget.interiorPadding,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class TopicsView extends StatelessWidget {
  const TopicsView({
    super.key,
    required this.topics,
    required this.onTap,
    required this.isSelected,
    this.isEnabled = true,
    this.interiorPadding,
    this.scrollable = false,
  });

  final List<Topic> topics;
  final void Function(Topic) onTap;
  final bool Function(Topic) isSelected;
  final bool isEnabled;
  final EdgeInsetsGeometry? interiorPadding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    late final Widget content;
    if (scrollable) {
      content = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: interiorPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: topics.asMap().mapDown((index, topic) {
            return _ListTopic(
              key: ValueKey(topic.name),
              index: index,
              topic: topic,
              isSelected: isSelected(topic),
              isEnabled: isEnabled,
              onTap: onTap,
            );
          }).toList(),
        ),
      );
    } else {
      content = Padding(
        padding: interiorPadding ?? EdgeInsets.zero,
        child: Wrap(
          children: topics.asMap().mapDown((index, topic) {
            return _ListTopic(
              key: ValueKey(topic.name),
              index: index,
              topic: topic,
              isSelected: isSelected(topic),
              isEnabled: true,
              onTap: onTap,
            );
          }).toList(),
        ),
      );
    }
    return content;
  }
}

/// Wrapper that handles badge padding logic.
class _ListTopic extends StatelessWidget {
  const _ListTopic({
    // Key is required because these get reordered in lists.
    required Key key,
    required this.index,
    required this.topic,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  }) : super(key: key);

  final int index;
  final Topic topic;
  final bool isSelected;
  final bool isEnabled;
  final void Function(Topic) onTap;

  @override
  Widget build(BuildContext context) {
    final TopicThemeData? theme = TopicViewTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: index == 0 || theme?.showNewCastsCount == false ? 0 : 6,
      ),
      child: TopicChip(
        key: ValueKey<Topic>(topic),
        topic: topic,
        isSelected: isSelected,
        isEnabled: isEnabled,
        onTap: () => onTap(topic),
      ),
    );
  }
}

class TopicChip extends StatelessWidget {
  const TopicChip({
    super.key,
    required this.topic,
    required this.isSelected,
    required this.onTap,
    this.isEnabled = true,
  });

  final Topic topic;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final Color color =
        AdaptiveMaterial.of(context) == AdaptiveMaterialType.background
            ? AdaptiveMaterialType.surface.colorOf(context)
            : AdaptiveMaterialType.background.colorOf(context);
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: FilterChip(
          showCheckmark: false,
          label: Text(
            topic.name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : null,
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

class TopicViewTheme extends InheritedWidget {
  const TopicViewTheme({
    super.key,
    required super.child,
    required this.data,
  });

  final TopicThemeData data;

  static TopicThemeData? of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<TopicViewTheme>()?.data;
  }

  @override
  bool updateShouldNotify(TopicViewTheme oldWidget) {
    return oldWidget.data != data;
  }
}

class TopicThemeData {
  const TopicThemeData({
    this.showNewCastsCount,
  });

  final bool? showNewCastsCount;
}

class TopicSelectorController with ChangeNotifier {
  TopicSelectorController({
    List<Topic>? filterTopics,
  }) : _filterTopics = filterTopics ?? [];

  /// If non-null, restrict casts to the given topic.
  List<Topic> _filterTopics;

  List<Topic> get filterTopics => _filterTopics;

  void toggle(Topic topic) {
    _filterTopics = _filterTopics.toggled(topic);
    notifyListeners();
  }

  void reset() {
    _filterTopics = [];
    notifyListeners();
  }
}

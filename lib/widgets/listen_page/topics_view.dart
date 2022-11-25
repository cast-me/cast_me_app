// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:badges/badges.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/util/collection_utils.dart';
import 'package:cast_me_app/util/listenable_utils.dart';

class TopicSelector extends StatefulWidget {
  const TopicSelector({
    super.key,
    this.interiorPadding,
    this.controller,
    required this.onTap,
    this.max,
  });

  final EdgeInsets? interiorPadding;
  final TopicsViewController? controller;
  final void Function(Topic) onTap;
  final int? max;

  @override
  State<TopicSelector> createState() => _TopicSelectorState();
}

class _TopicSelectorState extends State<TopicSelector> {
  Future<List<Topic>> allTopics = _getTopics();

  static Future<List<Topic>> _getTopics() async {
    return CastDatabase.instance.getAllTopics();
  }

  void _onRefresh() {
    setState(() {
      allTopics = _getTopics();
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onRefresh);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onRefresh);
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
            style: TextStyle(color: Theme.of(context).errorColor),
          );
        }
        if (!snap.hasData) {
          return Container();
        }
        final List<Topic> topics = snap.data!;
        return ValueListenableBuilder<List<Topic>>(
          // We get the actual topic objects from all topics as it has fresh
          // view and cast counts.
          valueListenable: widget.controller?.select(() {
                return widget.controller!.filterTopics
                    .map((f) => topics.singleWhere((t) => f.id == t.id))
                    .toList();
              }) ??
              ValueNotifier([]),
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
                  onTap: widget.onTap,
                  isSelected: (_) => false,
                  isEnabled: widget.max == null || numTopics < widget.max!,
                  interiorPadding: widget.interiorPadding,
                  scrollable: true,
                ),
                TopicsView(
                  topics: selectedTopics,
                  onTap: widget.onTap,
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
    Key? key,
    required this.topics,
    required this.onTap,
    required this.isSelected,
    this.isEnabled = true,
    this.interiorPadding,
    this.scrollable = false,
  }) : super(key: key);

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
        AdaptiveMaterial.of(context) == AdaptiveMaterialType.background
            ? AdaptiveMaterialType.surface.colorOf(context)
            : AdaptiveMaterialType.background.colorOf(context);
    final TopicThemeData? theme = TopicViewTheme.of(context);
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Badge(
          // TODO: this should be automatically refreshed when casts are
          //   listened to or added.
          badgeContent: Text(
            topic.newCastCount.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          showBadge:
              theme?.showNewCastsCount != false && topic.newCastCount != 0,
          position: const BadgePosition(top: 0, end: -7),
          badgeColor: Colors.white,
          toAnimate: false,
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
      ),
    );
  }
}

class TopicViewTheme extends InheritedWidget {
  const TopicViewTheme({
    Key? key,
    required Widget child,
    required this.data,
  }) : super(key: key, child: child);

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

abstract class TopicsViewController with ChangeNotifier {
  List<Topic> get filterTopics;
}

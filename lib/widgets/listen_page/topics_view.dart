// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:badges/badges.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/util/collection_utils.dart';
import 'package:cast_me_app/util/listenable_utils.dart';

class TopicsView extends StatefulWidget {
  TopicsView({
    Key? key,
    this.controller,
    required ValueListenable<List<Topic>> selectedTopics,
    required this.onTap,
    this.max,
  })  : selectedTopicIds =
            selectedTopics.map((topics) => topics.map((t) => t.id).toList()),
        super(key: key);

  final TopicsViewController? controller;
  final ValueListenable<List<String>> selectedTopicIds;
  final void Function(Topic) onTap;
  final int? max;

  @override
  State<TopicsView> createState() => _TopicsViewState();
}

class _TopicsViewState extends State<TopicsView> {
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
          valueListenable: widget.selectedTopicIds.map(
            (ids) =>
                ids.map((id) => topics.singleWhere((t) => t.id == id)).toList(),
          ),
          builder: (context, selectedTopics, _) {
            final numTopics = selectedTopics.length;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: topics
                        .where((t) => !selectedTopics.any((s) => s.id == t.id))
                        .toList()
                        .asMap()
                        .mapDown((index, topic) {
                      return _ListTopic(
                        key: ValueKey(topic.name),
                        index: index,
                        topic: topic,
                        isSelected: false,
                        isEnabled:
                            widget.max == null || numTopics < widget.max!,
                        onTap: widget.onTap,
                      );
                    }).toList(),
                  ),
                ),
                Wrap(
                  children: selectedTopics.asMap().mapDown((index, topic) {
                    return _ListTopic(
                      key: ValueKey(topic.name),
                      index: index,
                      topic: topic,
                      isSelected: true,
                      isEnabled: true,
                      onTap: widget.onTap,
                    );
                  }).toList(),
                ),
              ],
            );
          },
        );
      },
    );
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
        AdaptiveMaterial.adaptiveColorOf(context) == AdaptiveColor.background
            ? AdaptiveColor.surface.color(context)
            : AdaptiveColor.background.color(context);
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
            label: Text.rich(
              TextSpan(
                text: topic.name,
                children: [
                  if (theme?.showCount != false)
                    TextSpan(
                      text: ' ${topic.castCount}',
                    ),
                ],
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
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
    this.showCount,
    this.showNewCastsCount,
  });

  final bool? showCount;
  final bool? showNewCastsCount;
}

class TopicsViewController extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}

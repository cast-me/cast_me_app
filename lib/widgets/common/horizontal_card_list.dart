// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:expandable_page_view/expandable_page_view.dart';

class HorizontalCardList extends StatefulWidget {
  const HorizontalCardList({
    super.key,
    this.padding,
    this.pagePadding,
    required this.headerText,
    required this.pages,
  });

  final EdgeInsets? padding;

  /// Padding only to be applied internally to the page.
  ///
  /// Overrides `padding` for page contents.
  final EdgeInsets? pagePadding;
  final String headerText;
  final List<Widget> pages;

  @override
  State<HorizontalCardList> createState() => _HorizontalCardListState();
}

class _HorizontalCardListState extends State<HorizontalCardList> {
  final _PageController controller = _PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.headerText,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: controller.page == 0
                            ? null
                            : () {
                                controller.animateToPage(
                                  controller.page!.toInt() - 1,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.linear,
                                );
                              },
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: controller.page == widget.pages.length - 1
                            ? null
                            : () {
                                controller.animateToPage(
                                  controller.page!.toInt() + 1,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.linear,
                                );
                              },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        ExpandablePageView(
          controller: controller,
          children: widget.pages
              .map(
                (w) => Padding(
                  padding:
                      widget.pagePadding ?? widget.padding ?? EdgeInsets.zero,
                  child: w,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _PageController extends PageController {
  @override
  double? get page => hasClients ? super.page : 0;
}

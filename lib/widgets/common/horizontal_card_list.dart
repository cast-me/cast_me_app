import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:flutter/material.dart';
import 'package:expandable_page_view/expandable_page_view.dart';

class HorizontalCardList extends StatefulWidget {
  const HorizontalCardList({
    super.key,
    required this.pages,
  });

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
        ExpandablePageView(
          controller: controller,
          children: widget.pages,
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
          }
        ),
      ],
    );
  }
}

class _PageController extends PageController {
  @override
  double? get page => hasClients ? super.page : 0;
}

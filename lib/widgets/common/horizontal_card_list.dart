import 'package:flutter/material.dart';

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
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PageView(
          controller: controller,
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: controller.page != null && controller.page != 0
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
              onPressed: controller.page != null && controller.page != 0
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
        ),
      ],
    );
  }
}

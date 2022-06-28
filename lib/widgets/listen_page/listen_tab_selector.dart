import 'package:cast_me_app/models/cast_me_model.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/util/text_utils.dart';

import 'package:flutter/material.dart';

class ListenTabSelector extends StatelessWidget {
  const ListenTabSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        TextButton(
          onPressed: () {
            ListenModel.instance.onListenPageChanged(ListenPage.following);
          },
          child: ValueListenableBuilder<double>(
              valueListenable: ListenModel.instance.currentListenPage,
              builder: (context, page, _) {
                return Text(
                  'Following',
                  style: page < .5
                      ? Theme.of(context)
                          .textTheme
                          .headline4!
                          .asColor(AdaptiveMaterial.onColorOf(context)!)
                      : Theme.of(context).textTheme.headline5!.asColor(
                          AdaptiveMaterial.onColorOf(context)!.withAlpha(150)),
                );
              }),
        ),
        TextButton(
          onPressed: () {
            ListenModel.instance.onListenPageChanged(ListenPage.trending);
          },
          child: ValueListenableBuilder<double>(
              valueListenable: ListenModel.instance.currentListenPage,
              builder: (context, page, _) {
                return Text(
                  'Trending',
                  style: page > .5
                      ? Theme.of(context)
                          .textTheme
                          .headline4!
                          .asColor(AdaptiveMaterial.onColorOf(context)!)
                      : Theme.of(context).textTheme.headline5!.asColor(
                          AdaptiveMaterial.onColorOf(context)!.withAlpha(150)),
                );
              }),
        ),
      ],
    );
  }
}

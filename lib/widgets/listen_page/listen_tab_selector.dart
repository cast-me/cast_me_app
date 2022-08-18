import 'package:cast_me_app/business_logic/listen_bloc.dart';
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
            ListenBloc.instance.onListenPageChanged(ListenPage.following);
          },
          child: ValueListenableBuilder<double>(
              valueListenable: ListenBloc.instance.currentListenPage,
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
            ListenBloc.instance.onListenPageChanged(ListenPage.trending);
          },
          child: ValueListenableBuilder<double>(
              valueListenable: ListenBloc.instance.currentListenPage,
              builder: (context, page, _) {
                return Text(
                  'For You',
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

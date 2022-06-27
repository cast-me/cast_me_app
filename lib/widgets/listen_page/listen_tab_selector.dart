import 'package:cast_me_app/models/cast_me_model.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
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
          child: Text(
            'Following',
            style: Theme.of(context).textTheme.headline5!.copyWith(
                color: AdaptiveMaterial.onColorOf(context)!.withAlpha(150)),
          ),
        ),
        AdaptiveText(
          'Trending',
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}

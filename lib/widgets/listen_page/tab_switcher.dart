import 'package:cast_me_app/models/cast_me_model.dart';
import 'package:cast_me_app/widgets/listen_page/following_view.dart';
import 'package:cast_me_app/widgets/listen_page/trending_view.dart';
import 'package:flutter/material.dart';

class ListenTabView extends StatelessWidget {
  const ListenTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: ListenModel.instance.listenPageController,
      children: [
        const FollowingView(),
        TrendingView(),
      ],
    );
  }
}

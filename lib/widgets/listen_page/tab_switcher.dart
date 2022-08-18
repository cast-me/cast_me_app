import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/widgets/listen_page/for_you_view.dart';
import 'package:cast_me_app/widgets/listen_page/trending_view.dart';

import 'package:flutter/material.dart';

class ListenTabView extends StatelessWidget {
  const ListenTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: ListenBloc.instance.listenPageController,
      children: [
        const ForYouView(),
        TrendingView(),
      ],
    );
  }
}

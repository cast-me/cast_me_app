// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/listen_page/listen_casts_view.dart';
import 'package:cast_me_app/widgets/listen_page/topics_view.dart';

class ListenPageView extends StatefulWidget {
  const ListenPageView({Key? key}) : super(key: key);

  @override
  State<ListenPageView> createState() => _ListenPageViewState();
}

class _ListenPageViewState extends State<ListenPageView> {
  final TopicsViewController topicsController = TopicsViewController();

  @override
  void initState() {
    if (ListenBloc.instance.currentCast.value == null) {
      CastDatabase.instance.getSeedCast().then((cast) {
        // Seed the now playing cast with content on app launch.
        // Check a second time just in case the user has selected a cast while
        // we were getting the seed cast.
        if (cast != null && ListenBloc.instance.currentCast.value == null) {
          ListenBloc.instance.onCastSelected(cast, autoPlay: false);
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveMaterial(
      adaptiveColor: AdaptiveColor.background,
      child: SafeArea(
        bottom: false,
        child: NotificationListener<CastListRefreshNotification>(
          onNotification: (_) {
            topicsController.refresh();
            return false;
          },
          child: Column(
            children: [
              TopicsView(
                interiorPadding: const EdgeInsets.symmetric(horizontal: 8),
                controller: topicsController,
                selectedTopics: ListenBloc.instance.filteredTopics,
                onTap: ListenBloc.instance.onTopicToggled,
              ),
              const Expanded(
                child: ListenCastsView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

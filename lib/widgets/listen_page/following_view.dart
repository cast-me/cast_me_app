import 'package:async_list_view/async_list_view.dart';

import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/cast_view.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

class FollowingView extends StatelessWidget {
  const FollowingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AsyncListView<Cast>(
      stream: CastDatabase.instance.getCasts().handleError((error) {
        if (kDebugMode) {
          print(error);
        }
      }),
      itemBuilder: (
        context,
        snapshot,
        index,
      ) {
        if (!snapshot.hasData) {
          return const AdaptiveText("loading...");
        }
        return CastPreview(cast: snapshot.data![index]);
      },
    );
  }
}

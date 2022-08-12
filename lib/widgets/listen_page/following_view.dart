import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';

import 'package:flutter/material.dart';

class FollowingView extends StatelessWidget {
  const FollowingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CastListView(
      filterOutProfile: AuthManager.instance.profile,
      padding: const EdgeInsets.all(8),
    );
  }
}

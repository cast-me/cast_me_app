import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/common/profile_picture_view.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final Profile profile;

  bool get isSelf => profile.username == AuthManager.instance.profile.username;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Center(
              child: ProfilePictureView(profile: profile),
            ),
            const SizedBox(width: 8),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.headline6!,
              child: Column(
                children: [
                  Center(child: Text('@${profile.username}')),
                  Center(child: Text(profile.displayName)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: AdaptiveText(
            'Casts:',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Expanded(
          child: CastViewTheme(
            isInteractive: false,
            hideDelete: profile != AuthManager.instance.profile,
            indentReplies: false,
            child: CastListView(
              filterProfile: profile,
            ),
          ),
        ),
      ],
    );
  }
}

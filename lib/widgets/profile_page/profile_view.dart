// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/common/hide_if_deleted.dart';
import 'package:cast_me_app/widgets/common/profile_picture_view.dart';

class ProfilePreview extends StatelessWidget {
  const ProfilePreview({
    Key? key,
    required this.profile,
    this.onTap
  }) : super(key: key);

  final Profile profile;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return HideIfDeleted(
      isDeleted: profile.deleted,
      child: GestureDetector(
        onTap: onTap ?? () {
          CastMeBloc.instance.onProfileSelected(profile);
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(profile.profilePictureUrl),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('@${profile.username}'),
                  Text(profile.displayName),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
          child: Text(
            'Casts:',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Expanded(
          child: CastViewTheme(
            isInteractive: false,
            indentReplies: false,
            indicateNew: false,
            child: CastListView(
              controller: CastMeListController(filterProfile: profile),
            ),
          ),
        ),
      ],
    );
  }
}

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/models/profile_bloc.dart';
import 'package:cast_me_app/business_logic/models/profile_form_data.dart';
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/util/object_utils.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_error_view.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/complete_profile_view.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:cast_me_app/widgets/common/cast_menu.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/common/hide_if_deleted.dart';
import 'package:cast_me_app/widgets/common/profile_picture_view.dart';
import 'package:cast_me_app/widgets/profile_page/default_picture.dart';

class ProfilePreview extends StatelessWidget {
  const ProfilePreview({
    super.key,
    required this.profile,
    this.onTap,
  });

  final Profile profile;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return HideIfDeleted(
      isDeleted: profile.deleted,
      child: GestureDetector(
        onTap: onTap ??
            () {
              CastMeBloc.instance.onProfileSelected(profile);
            },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(
                height: 50,
                width: 50,
                child: profile.profilePictureUrl == null
                    ? DefaultPicture(displayName: profile.displayName)
                    : null,
                decoration: BoxDecoration(
                  image: profile.profilePictureUrl.apply(
                    (url) => DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(url),
                    ),
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
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileHeader(profile: profile),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Casts:',
            style: Theme.of(context).textTheme.headlineSmall,
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

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
    this.form,
  });

  final Profile profile;
  final ProfileFormData? form;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfilePictureView(
          profile: profile,
          form: form,
        ),
        const SizedBox(width: 8),
        DefaultTextStyle(
          style: Theme.of(context).textTheme.titleLarge!,
          child: Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('@${profile.username}'),
                if (form == null)
                  Text(profile.displayName)
                else
                  DisplayNamePicker(
                    controller: form!.displayNameController,
                    validate: form!.validateDisplayName,
                  ),
                if (profile.isSelf) _EditProfileButton(form: form),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton({required this.form});

  final ProfileFormData? form;

  @override
  Widget build(BuildContext context) {
    if (form == null) {
      return MenuButton(
        icon: Icons.edit,
        text: 'edit profile',
        onTap: ProfileBloc.instance.onEditProfile,
      );
    }
    return ValueListenableBuilder<bool>(
      valueListenable: form!.select(
        (f) =>
            (form!.displayNameChanged || form!.selectedPhoto != null) &&
            form!.validateDisplayName() == null,
      ),
      builder: (context, isEnabled, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AsyncMenuButton(
                  isEnabled: isEnabled,
                  icon: Icons.check,
                  text: 'save',
                  onTap: ProfileBloc.instance.onSubmit,
                ),
                AsyncMenuButton(
                  icon: Icons.close,
                  text: 'cancel',
                  onTap: ProfileBloc.instance.onCancel,
                ),
              ],
            ),
            const AuthErrorView(),
          ],
        );
      },
    );
  }
}

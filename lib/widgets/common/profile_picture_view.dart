// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_cropper/image_cropper.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/profile_form_data.dart';
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/util/object_utils.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_flow/complete_profile_view.dart';
import 'package:cast_me_app/widgets/profile_page/default_picture.dart';

class ProfilePictureView extends StatelessWidget {
  const ProfilePictureView({
    super.key,
    required this.profile,
    required this.form,
  });

  final Profile profile;
  final ProfileFormData? form;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CroppedFile?>(
      valueListenable: form == null
          ? ValueNotifier<CroppedFile?>(null)
          : form!.select((f) => f.selectedPhoto),
      builder: (context, selectedPhoto, child) {
        final ImageProvider<Object>? imageProvider = form?.selectedPhoto != null
            ? FileImage(form!.selectedPhoto!.file)
            : profile.profilePictureUrl.apply(
                (url) => CachedNetworkImageProvider(url),
              );
        if (imageProvider == null) {
          return _ProfilePictureWrapper(
            child: Stack(
              children: [
                Positioned.fill(
                  child: DefaultPicture(displayName: profile.displayName),
                ),
                if (form != null)
                  Positioned.fill(
                    child: _PictureEditButton(form: form!),
                  ),
              ],
            ),
          );
        }
        return ProfilePictureBaseView(
          imageProvider: imageProvider,
          child: form != null ? _PictureEditButton(form: form!) : null,
        );
      },
    );
  }
}

class _ProfilePictureWrapper extends StatelessWidget {
  const _ProfilePictureWrapper({
    this.child,
    this.decoration,
  });

  final Widget? child;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        height: 150,
        width: 150,
        decoration: decoration,
        child: child,
      ),
    );
  }
}

class ProfilePictureBaseView extends StatelessWidget {
  const ProfilePictureBaseView({
    super.key,
    this.imageProvider,
    this.child,
  });

  final ImageProvider? imageProvider;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: _ProfilePictureWrapper(
        decoration: BoxDecoration(
          image: imageProvider.apply(
            (i) => DecorationImage(
              fit: BoxFit.cover,
              image: i,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}

class _PictureEditButton extends StatelessWidget {
  const _PictureEditButton({required this.form});

  final ProfileFormData form;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () => onProfilePictureSelected(form),
      child: Container(
        color: Colors.black54,
        child: const Icon(
          Icons.image_search,
          size: 40,
        ),
      ),
    );
  }
}

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/models/profile_form_data.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/util/object_utils.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_error_view.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/common/profile_picture_view.dart';

/// TODO(caseycrogers): Consider migrating this mess to Flutter's shitty built
///   form system.
class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final ProfileFormData form = ProfileFormData();

  @override
  Widget build(BuildContext context) {
    return CastMePage(
      child: Column(
        children: [
          Text(
            'Welcome to CastMe!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Text(
            '\nLets finish your profile.\n\n'
            'Please enter a username. All other fields are optional and can be '
            'changed later.\n',
            textAlign: TextAlign.center,
          ),
          _UsernamePicker(form: form),
          DisplayNamePicker(
            controller: form.displayNameController,
            validate: form.validateDisplayName,
          ),
          const SizedBox(height: 8),
          _ProfilePicturePicker(form: form),
          AsyncActionWrapper(
            controller: AuthManager.instance.asyncActionController,
            child: AnimatedBuilder(
              animation: form,
              builder: (context, _) {
                return AsyncElevatedButton(
                  action: 'complete profile',
                  child: const Text('Submit'),
                  onTap: form.isValid()
                      ? () async {
                          await AuthManager.instance.completeUserProfile(
                            username: form.usernameController.text,
                            displayName: form.displayNameController.text,
                            profilePicture:
                                form.selectedPhoto.apply((p) => File(p.path)),
                          );
                        }
                      : null,
                );
              },
            ),
          ),
          const AuthErrorView(),
        ],
      ),
    );
  }
}

class _ProfilePicturePicker extends StatelessWidget {
  const _ProfilePicturePicker({
    required this.form,
  });

  final ProfileFormData form;

  @override
  Widget build(BuildContext context) {
    return AsyncActionWrapper(
      child: ValueListenableBuilder<CroppedFile?>(
        valueListenable: form.select((f) => f.selectedPhoto),
        builder: (context, photo, _) {
          return Column(
            children: [
              if (photo != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ProfilePictureBaseView(
                    imageProvider: FileImage(
                      File(photo.path),
                    ),
                  ),
                ),
              AsyncElevatedButton(
                action: 'profile picture',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.image),
                    const SizedBox(width: 6),
                    Text(
                      photo == null
                          ? 'Select profile picture (optional)'
                          : 'Replace profile picture',
                    ),
                  ],
                ),
                onTap: () => onProfilePictureSelected(form),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DisplayNamePicker extends StatelessWidget {
  DisplayNamePicker({
    required this.controller,
    required this.validate,
  });

  final TextEditingController controller;
  final String? Function() validate;
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: errorMessage,
      builder: (context, message, _) {
        return TextField(
          controller: controller,
          onChanged: (displayName) {
            errorMessage.value = validate();
          },
          decoration: InputDecoration(
            labelText: 'display name (optional)',
            errorText: message,
          ),
        );
      },
    );
  }
}

class _UsernamePicker extends StatelessWidget {
  _UsernamePicker({
    required this.form,
  });

  final ProfileFormData form;
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: errorMessage,
      builder: (context, message, _) {
        return TextField(
          controller: form.usernameController,
          onChanged: (displayName) {
            errorMessage.value = form.validateUsername();
          },
          decoration: InputDecoration(
            labelText: 'username (must be unique)',
            errorText: message,
          ),
        );
      },
    );
  }
}

Future<void> onProfilePictureSelected(ProfileFormData form) async {
  final XFile? file =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  if (file == null) {
    return;
  }

  final CroppedFile? croppedImage = await ImageCropper.platform.cropImage(
    sourcePath: file.path,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    cropStyle: CropStyle.rectangle,
  );
  if (croppedImage == null) {
    return;
  }
  form.selectedPhoto = croppedImage;
}

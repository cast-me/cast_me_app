import 'dart:io';

import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/models/profile_form_data.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_error_view.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_submit_button_wrapper.dart';
import 'package:cast_me_app/widgets/common/async_submit_button.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/common/profile_picture_view.dart';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';

/// TODO(caseycrogers): Consider migrating this mess to Flutter's shitty built
///   form system.
class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({Key? key}) : super(key: key);

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final ProfileFormData form = ProfileFormData();

  @override
  Widget build(BuildContext context) {
    return CastMePage(
      headerText: 'Profile',
      child: Column(
        children: [
          _UsernamePicker(form: form),
          _DisplayNamePicker(form: form),
          _ProfilePicturePicker(form: form),
          AuthSubmitButtonWrapper(
            child: AnimatedBuilder(
              animation: form,
              builder: (context, _) {
                return ElevatedButton(
                  onPressed: form.isValid()
                      ? () async {
                          await AuthManager.instance.completeUserProfile(
                            username: form.usernameController.text,
                            displayName: form.displayNameController.text,
                            profilePicture: File(form.selectedPhoto!.path),
                          );
                        }
                      : null,
                  child: const Text('Submit'),
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
    Key? key,
    required this.form,
  }) : super(key: key);

  final ProfileFormData form;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CroppedFile?>(
      valueListenable: form.select(() => form.selectedPhoto),
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
            AsyncSubmitButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.image),
                  const SizedBox(width: 6),
                  Text(
                    photo == null
                        ? 'Select profile picture'
                        : 'Replace profile picture',
                  ),
                ],
              ),
              onPressed: () async {
                final XFile? file =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (file == null) {
                  return;
                }

                final CroppedFile? croppedImage =
                    await ImageCropper.platform.cropImage(
                  sourcePath: file.path,
                  aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                  cropStyle: CropStyle.circle,
                );
                if (croppedImage == null) {
                  return;
                }
                form.selectedPhoto = croppedImage;
              },
            ),
          ],
        );
      },
    );
  }
}

class _DisplayNamePicker extends StatelessWidget {
  _DisplayNamePicker({
    Key? key,
    required this.form,
  }) : super(key: key);

  final ProfileFormData form;
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: errorMessage,
      builder: (context, message, _) {
        return TextField(
          controller: form.displayNameController,
          onChanged: (displayName) {
            errorMessage.value = form.validateDisplayName();
          },
          decoration: InputDecoration(
            labelText: 'display name',
            errorText: message,
          ),
        );
      },
    );
  }
}

class _UsernamePicker extends StatelessWidget {
  _UsernamePicker({
    Key? key,
    required this.form,
  }) : super(key: key);

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
            labelText: 'username',
            errorText: message,
          ),
        );
      },
    );
  }
}

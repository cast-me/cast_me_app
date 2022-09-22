import 'dart:io';

import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_error_view.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_submit_button_wrapper.dart';
import 'package:cast_me_app/widgets/common/async_submit_button.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/common/profile_picture_view.dart';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({Key? key}) : super(key: key);

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final ValueNotifier<CroppedFile?> selectedPhoto = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return CastMePage(
      headerText: 'Complete Profile',
      child: Column(
        children: [
          _UsernamePicker(controller: usernameController),
          _DisplayNamePicker(controller: displayNameController),
          _ProfilePicturePicker(selectedPhoto: selectedPhoto),
          AuthSubmitButtonWrapper(
            child: ValueListenableBuilder<CroppedFile?>(
                valueListenable: selectedPhoto,
                builder: (context, photo, _) {
                  return ElevatedButton(
                    onPressed: selectedPhoto.value != null
                        ? () async {
                            await AuthManager.instance.completeUserProfile(
                              username: usernameController.text,
                              displayName: displayNameController.text,
                              profilePicture: File(selectedPhoto.value!.path),
                            );
                          }
                        : null,
                    child: const Text('Submit'),
                  );
                }),
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
    required this.selectedPhoto,
  }) : super(key: key);

  final ValueNotifier<CroppedFile?> selectedPhoto;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CroppedFile?>(
        valueListenable: selectedPhoto,
        builder: (context, photo, _) {
          return Column(
            children: [
              if (photo != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ProfilePictureBaseView(
                    imageProvider: FileImage(
                      File(selectedPhoto.value!.path),
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
                  final XFile? file = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
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
                  selectedPhoto.value = croppedImage;
                },
              ),
            ],
          );
        });
  }
}

class _DisplayNamePicker extends StatefulWidget {
  const _DisplayNamePicker({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<_DisplayNamePicker> createState() => _DisplayNamePickerState();
}

class _DisplayNamePickerState extends State<_DisplayNamePicker> {
  String? errorMessage;
  bool hasChanged = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (displayName) {
        hasChanged = true;
        if (displayName.length < 4) {
          errorMessage = 'Display name must be at least 4 characters.';
          setState(() {});
          return;
        }
        if (displayName.length > 50) {
          errorMessage = 'Display name must be less than 50 characters.';
          setState(() {});
          return;
        }
        setState(() {});
        errorMessage = null;
      },
      decoration: InputDecoration(
        labelText: 'display name',
        errorText: errorMessage,
      ),
    );
  }
}

class _UsernamePicker extends StatefulWidget {
  const _UsernamePicker({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<_UsernamePicker> createState() => _UsernamePickerState();
}

class _UsernamePickerState extends State<_UsernamePicker> {
  String? errorMessage;
  bool hasChanged = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (displayName) {
        hasChanged = true;
        if (displayName.length < 4) {
          errorMessage = 'Display name must be at least 4 characters.';
          setState(() {});
          return;
        }
        if (displayName.length > 50) {
          errorMessage = 'Display name must be less than 50 characters.';
          setState(() {});
          return;
        }
        setState(() {});
        errorMessage = null;
      },
      decoration: InputDecoration(
        labelText: 'username',
        errorText: errorMessage,
      ),
    );
  }
}

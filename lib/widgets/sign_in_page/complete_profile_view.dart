import 'dart:io';

import 'package:cast_me_app/widgets/sign_in_page/auth_error_view.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_flow_builder.dart';
import 'package:cast_me_app/widgets/sign_in_page/auth_submit_button_wrapper.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({Key? key}) : super(key: key);

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final ValueNotifier<XFile?> selectedPhoto = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return AuthFlowBuilder(builder: (context, authManager, _) {
      return Column(
        children: [
          Text(
            'Complete your profile',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3,
          ),
          _UsernamePicker(controller: usernameController),
          _DisplayNamePicker(controller: displayNameController),
          _ProfilePicturePicker(selectedPhoto: selectedPhoto),
          AuthSubmitButtonWrapper(
            child: ValueListenableBuilder<XFile?>(
              valueListenable: selectedPhoto,
              builder: (context, photo, _) {
                return ElevatedButton(
                  onPressed: selectedPhoto.value != null
                      ? () async {
                          await authManager.completeUserProfile(
                            username: usernameController.text,
                            displayName: displayNameController.text,
                            profilePicture: File(selectedPhoto.value!.path),
                          );
                        }
                      : null,
                  child: const Text('Submit'),
                );
              }
            ),
          ),
          const AuthErrorView(),
        ],
      );
    });
  }
}

class _ProfilePicturePicker extends StatelessWidget {
  const _ProfilePicturePicker({
    Key? key,
    required this.selectedPhoto,
  }) : super(key: key);

  final ValueNotifier<XFile?> selectedPhoto;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<XFile?>(
        valueListenable: selectedPhoto,
        builder: (context, photo, _) {
          return Column(
            children: [
              if (photo != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.file(
                        File(photo.path),
                      ),
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: () async {
                  selectedPhoto.value = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                },
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

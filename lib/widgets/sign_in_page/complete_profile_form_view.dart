import 'dart:io';

import 'package:cast_me_app/business_logic/clients/auth_manager.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class CompleteProfileFormView extends StatefulWidget {
  const CompleteProfileFormView({Key? key}) : super(key: key);

  @override
  State<CompleteProfileFormView> createState() =>
      _CompleteProfileFormViewState();
}

class _CompleteProfileFormViewState extends State<CompleteProfileFormView> {
  ValueNotifier<XFile?> selectedPhoto = ValueNotifier(null);
  Future<void> isSubmitting = Future.value();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _DisplayNamePicker(),
        _ProfilePicturePicker(selectedPhoto: selectedPhoto),
        ElevatedButton(
          onPressed: selectedPhoto.value != null ? () {
            setState(() {
              isSubmitting = AuthManager.instance
                  .setUserPhoto(File(selectedPhoto.value!.path));
            });
          } : null,
          child: const Text('submit'),
        ),
      ],
    );
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
    return ElevatedButton(
      onPressed: () async {
        selectedPhoto.value =
            await ImagePicker().pickImage(source: ImageSource.gallery);
      },
      child: ValueListenableBuilder<XFile?>(
          valueListenable: selectedPhoto,
          builder: (context, photo, _) {
            if (photo == null) {
              return const Text('Select profile picture');
            }
            return Image.file(
              File(photo.path),
            );
          }),
    );
  }
}

class _DisplayNamePicker extends StatefulWidget {
  const _DisplayNamePicker({Key? key}) : super(key: key);

  @override
  State<_DisplayNamePicker> createState() => _DisplayNamePickerState();
}

class _DisplayNamePickerState extends State<_DisplayNamePicker> {
  String? errorMessage;
  bool hasChanged = false;
  Future<void> isWriting = Future.value();

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (displayName) {
        hasChanged = true;
        if (displayName.length < 4) {
          errorMessage = 'Display name must be at least 4 characters.';
          return;
        }
        if (displayName.length > 50) {
          errorMessage = 'Display name must be less than 50 characters.';
          return;
        }
        isWriting = AuthManager.instance
            .setDisplayName(displayName)
            .then((value) => null)
            .onError((error, stackTrace) {
          setState(() {
            errorMessage = error.toString();
          });
          return null;
        });
      },
      decoration: InputDecoration(
        errorText: errorMessage,
      ),
    );
  }
}

import 'dart:io';

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
  ValueNotifier<XFile?> selectedPhoto = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _DisplayNamePicker(),
        _ProfilePicturePicker(selectedPhoto: selectedPhoto),
        AuthFlowBuilder(builder: (context, authManager, _) {
          return AuthSubmitButtonWrapper(
            child: ElevatedButton(
              onPressed: selectedPhoto.value != null
                  ? () {
                      authManager.setUserPhoto(File(selectedPhoto.value!.path));
                    }
                  : null,
              child: const Text('Submit'),
            ),
          );
        }),
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

  @override
  Widget build(BuildContext context) {
    return TextField(
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

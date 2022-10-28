// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:image_cropper/image_cropper.dart';

class ProfileFormData extends ChangeNotifier {
  late final TextEditingController usernameController = TextEditingController()
    ..addListener(notifyListeners);
  late final TextEditingController displayNameController =
      TextEditingController()..addListener(notifyListeners);

  CroppedFile? _selectedPhoto;

  CroppedFile? get selectedPhoto => _selectedPhoto;

  set selectedPhoto(CroppedFile? value) {
    _selectedPhoto = value;
    notifyListeners();
  }

  bool isValid() {
    if (validateUsername() != null) {
      return false;
    }
    if (validateDisplayName() != null) {
      return false;
    }
    if (selectedPhoto == null) {
      return false;
    }
    return true;
  }

  static const String usernameInfo = 'Your username uniquely identifies you.\n'
      'It\s used when people try to tag you in a post. It cannot be changed.\n'
      '\n'
      'Usernames can only contain alpha numeric characters, underscores, and '
      'hyphens.';

  static const String displayNameInfo = 'Your display name is used to show who '
      'you are.\n'
      'It does not have to be unique and can be changed as many times as you '
      'would like. It can contain arbitrary characters (even emojis!)';

  String? validateUsername() {
    final String username = usernameController.text;
    if (username.length < 4) {
      return 'Display name must be at least 4 characters.';
    }
    if (username.length > 50) {
      return 'Display name must be less than 50 characters.';
    }
    if (!RegExp(r'^[\p{Letter}0-9_]+$', unicode: true).hasMatch(username)) {
      return 'Usernames may only contain letters, numbers or underscores.';
    }
    return null;
  }

  String? validateDisplayName() {
    final String displayName = displayNameController.text;
    if (displayName.length < 4) {
      return 'Display name must be at least 4 characters.';
    }
    if (displayName.length > 50) {
      return 'Display name must be less than 50 characters.';
    }
    return null;
  }

  @override
  void dispose() {
    usernameController.removeListener(notifyListeners);
    displayNameController.removeListener(notifyListeners);
    super.dispose();
  }
}

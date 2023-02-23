// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/models/profile_form_data.dart';
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileBloc {
  ProfileBloc._();

  static final ProfileBloc instance = ProfileBloc._();

  Profile get profile => AuthManager.instance.profile;

  final ValueNotifier<ProfileFormData?> _form = ValueNotifier(null);

  ValueListenable<ProfileFormData?> get form => _form;

  Future<void> onEditProfile() async {
    assert(_form.value == null);
    _form.value = ProfileFormData.forEditing(
      initialUsername: profile.username,
      initialDisplayName: profile.displayName,
    );
  }

  Future<void> onSubmit() async {
    assert(_form.value != null);
    final ProfileFormData form = _form.value!;
    final String actualDisplayName = form.currentDisplayName.isEmpty
        ? form.usernameController.text
        : form.currentDisplayName;
    await AuthManager.instance.updateFields(
      displayName: form.displayNameChanged ? actualDisplayName : null,
      profilePicture: form.selectedPhoto?.file,
    );
    _form.value = null;
  }

  Future<void> onCancel() async {
    assert(_form.value != null);
    _form.value = null;
  }

  void onEditProfileImage() {
    _form.value = ProfileFormData.forEditing(
      initialUsername: profile.username,
      initialDisplayName: profile.displayName,
    );
  }
}

import 'package:cast_me_app/business_logic/models/profile_bloc.dart';
import 'package:cast_me_app/business_logic/models/profile_form_data.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/widgets/profile_page/profile_view.dart';
import 'package:flutter/material.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    super.key,
    required this.form,
  });

  final ProfileFormData form;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  @override
  void dispose() {
    // If the user navigates away from the edit profile view we should cancel
    // the edits.
    if (ProfileBloc.instance.form.isNotEmpty) {
      ProfileBloc.instance.onCancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncActionWrapper(
      child: ProfileHeader(
        profile: ProfileBloc.instance.profile,
        form: widget.form,
      ),
    );
  }
}

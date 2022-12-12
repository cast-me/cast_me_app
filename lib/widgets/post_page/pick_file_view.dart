// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';

// Project imports:
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';

class PickFileView extends StatelessWidget {
  const PickFileView({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncElevatedButton(
      action: 'pick file',
      child: const Text('Select a file'),
      onTap: () async {
        final FilePickerResult? pickerResult =
            await FilePicker.platform.pickFiles(
          dialogTitle: 'Select audio',
          type: FileType.custom,
          allowedExtensions: ['mp3', 'm4a'],
        );
        if (pickerResult != null && pickerResult.files.isNotEmpty) {
          PostBloc.instance
              .onFileSelected(Future.value(pickerResult.files.first.path!));
        }
      },
    );
  }
}

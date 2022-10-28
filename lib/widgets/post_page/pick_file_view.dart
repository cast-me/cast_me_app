// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';

class PickFileView extends StatelessWidget {
  const PickFileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AsyncActionWrapper wrapper = AsyncActionWrapper.of(context);
    return ValueListenableBuilder<CastFile?>(
      valueListenable: PostBloc.instance.castFile,
      builder: (context, castFiles, _) {
        return ElevatedButton(
          onPressed: () async {
            await wrapper.wrap(
              'pick file',
              () async {
                final FilePickerResult? pickerResult =
                    await FilePicker.platform.pickFiles(
                  dialogTitle: 'Select audio',
                  type: FileType.custom,
                  allowedExtensions: ['mp3', 'm4a'],
                );
                if (pickerResult != null && pickerResult.files.isNotEmpty) {
                  await PostBloc.instance
                      .onFileSelected(pickerResult.files.first.path!);
                }
              },
            );
          },
          child: const Text('Select a file'),
        );
      },
    );
  }
}

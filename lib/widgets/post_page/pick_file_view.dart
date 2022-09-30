import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PickFileView extends StatelessWidget {
  const PickFileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CastFile>>(
        valueListenable: PostBloc.instance.castFiles,
        builder: (context, castFiles, _) {
          return ElevatedButton(
            onPressed: () async {
              final FilePickerResult? pickerResult =
                  await FilePicker.platform.pickFiles(
                dialogTitle: 'Select audio',
                type: FileType.custom,
                allowedExtensions: ['mp3', 'm4a'],
                allowMultiple: true,
              );
              if (pickerResult != null && pickerResult.files.isNotEmpty) {
                await PostBloc.instance.onFilesSelected(
                  pickerResult.files.map((f) => f.path!),
                );
              }
            },
            child: const Text('Select a file'),
          );
        });
  }
}

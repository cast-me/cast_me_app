import 'dart:io';

import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PostPageView extends StatefulWidget {
  const PostPageView({Key? key}) : super(key: key);

  @override
  State<PostPageView> createState() => _PostPageViewState();
}

class _PostPageViewState extends State<PostPageView> {
  final ValueNotifier<File?> currentFile = ValueNotifier(null);
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AdaptiveMaterial(
      adaptiveColor: AdaptiveColor.surface,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Upload Cast'),
          ElevatedButton(
            child: ValueListenableBuilder<File?>(
                valueListenable: currentFile,
                builder: (context, file, _) {
                  if (file == null) {
                    return const Text('select audio');
                  }
                  return const Text('Replace selected audio');
                }),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                dialogTitle: 'Select audio',
                type: FileType.audio,
              );
              if (result != null) {
                currentFile.value = File(result.files.single.path!);
              }
            },
          ),
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'cast title',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await CastDatabase.instance.createCast(
                title: textController.text,
                file: currentFile.value!,
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

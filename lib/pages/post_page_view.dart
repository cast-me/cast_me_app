import 'dart:io';

import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/async_submit_button.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PostPageView extends StatefulWidget {
  const PostPageView({Key? key}) : super(key: key);

  @override
  State<PostPageView> createState() => _PostPageViewState();
}

class _PostPageViewState extends State<PostPageView> {
  File? file;
  final TextEditingController textController = TextEditingController();

  // Used to externally force the cast list to rebuild with a new stream.
  ValueNotifier<Key> listKey = ValueNotifier(UniqueKey());

  @override
  Widget build(BuildContext context) {
    return AdaptiveMaterial(
      adaptiveColor: AdaptiveColor.surface,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('Upload Cast'),
            ElevatedButton(
              onPressed: () async {
                final FilePickerResult? result =
                    await FilePicker.platform.pickFiles(
                  dialogTitle: 'Select audio',
                  type: FileType.audio,
                );
                if (result != null) {
                  setState(() {
                    file = File(result.files.single.path!);
                  });
                }
              },
              child: const Text('Select audio'),
            ),
            if (file != null) Text(file!.uri.pathSegments.last),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Cast title',
              ),
            ),
            AnimatedBuilder(
                animation: textController,
                builder: (context, child) {
                  return AsyncSubmitButton(
                    child: const Text('Submit'),
                    onPressed: file != null && textController.text.isNotEmpty
                        ? () async {
                            await CastDatabase.instance.createCast(
                              title: textController.text,
                              file: file!,
                            );
                            // Force rebuild of the cast list.
                            listKey.value = UniqueKey();
                          }
                        : null,
                  );
                }),
            const AdaptiveText('Your casts'),
            SizedBox(
              height: 300,
              child: ValueListenableBuilder<Key>(
                  valueListenable: listKey,
                  builder: (context, key, _) {
                    return CastListView(
                      // Use this to force rebuilding with a new stream.
                      key: key,
                      filterProfile: AuthManager.instance.profile,
                      fullyInteractive: false,
                      padding: EdgeInsets.zero,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

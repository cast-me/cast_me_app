import 'dart:io';

import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/async_submit_button.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

class PostPageView extends StatefulWidget {
  const PostPageView({Key? key}) : super(key: key);

  @override
  State<PostPageView> createState() => _PostPageViewState();
}

class _PostPageViewState extends State<PostPageView> {
  File? file;
  final TextEditingController textController = TextEditingController();

  // Used to externally force the cast list to rebuild with a new strFeam.
  Key listKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return CastMePage(
      headerText: 'Post',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
              'Currently, ONLY `.mp3` and `.m4a` files are supported. '
              'More file types and the ability to record and edit clips '
              'in-app will be added.\n'
              '\n'
              'Recommended external recording app:'),
          if (Platform.isIOS)
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  LaunchReview.launch(
                    iOSAppId: '1069512134',
                    writeReview: false,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: AdaptiveText(
                    'Voice Memos',
                    style:
                        TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ),
          if (Platform.isAndroid)
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  LaunchReview.launch(
                    androidAppId: 'com.zaza.beatbox',
                    writeReview: false,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: AdaptiveText(
                    'Pro Audio Editor',
                    style:
                        TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ),
          ElevatedButton(
            onPressed: () async {
              final FilePickerResult? result =
                  await FilePicker.platform.pickFiles(
                dialogTitle: 'Select audio',
                type: FileType.custom,
                allowedExtensions: ['mp3', 'm4a'],
              );
              if (result != null) {
                setState(() {
                  file = File(result.files.single.path!);
                });
              }
            },
            child: const Text('Select audio'),
          ),
          Text(
            file != null ? file!.uri.pathSegments.last : '',
          ),
          TextField(
            controller: textController,
            decoration: const InputDecoration(labelText: 'Cast title'),
          ),
          AnimatedBuilder(
              animation: textController,
              builder: (context, child) {
                return AsyncSubmitButton(
                  child: const Text('Submit'),
                  onPressed:
                      file != null && textController.text.isNotEmpty
                          ? () async {
                              await CastDatabase.instance.createCast(
                                title: textController.text,
                                file: file!,
                              );
                              setState(() {
                                // Force rebuild of the cast list.
                                listKey = UniqueKey();
                                file = null;
                                textController.clear();
                              });
                            }
                          : null,
                );
              }),
          const AdaptiveText('Your casts'),
          const SizedBox(height: 4),
          Expanded(
            child: CastListView(
              // Use this to force rebuilding with a new stream.
              key: listKey,
              filterProfile: AuthManager.instance.profile,
              fullyInteractive: false,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/async_submit_button.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/poast_page/audio_recorder_recommender.dart';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';

class PostPageView extends StatefulWidget {
  const PostPageView({Key? key}) : super(key: key);

  @override
  State<PostPageView> createState() => _PostPageViewState();
}

class _PostPageViewState extends State<PostPageView> {
  final TextEditingController textController = TextEditingController();
  final ValueNotifier<Cast?> replyCast = ValueNotifier(null);
  final CastListController castListController = CastListController();

  @override
  Widget build(BuildContext context) {
    return CastMePage(
      headerText: 'Post',
      child: ValueListenableBuilder<List<CastFile>>(
          valueListenable: PostBloc.instance.castFiles,
          builder: (context, castFiles, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                    'Currently, ONLY `.mp3` and `.m4a` files are supported. '
                    'More file types and the ability to record and edit clips '
                    'in-app will be added.\n'
                    '\n'
                    'Recommended external recording app:'),
                const AudioRecorderRecommender(),
                const AdaptiveText('Cast file:'),
                ElevatedButton(
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
                  child: const Text('Select audio'),
                ),
                Text(
                  castFiles.isNotEmpty ? castFiles.first.platformFile.name : '',
                ),
                //ReplyCastSelector(replyCast: replyCast),
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(labelText: 'Cast title'),
                ),
                AnimatedBuilder(
                    animation: textController,
                    builder: (context, child) {
                      return AsyncSubmitButton(
                        child: const Text('Submit'),
                        onPressed: castFiles.isNotEmpty &&
                                textController.text.isNotEmpty
                            ? () async {
                                await CastDatabase.instance.createCast(
                                  title: textController.text,
                                  castFile: castFiles.first,
                                );
                                // No need to call setState as updating the
                                // castFiles list in postBloc will do that.
                                castListController.refresh();
                                textController.clear();
                                PostBloc.instance.popFirstFile();
                              }
                            : null,
                      );
                    }),
                const AdaptiveText('Your casts'),
                const SizedBox(height: 4),
                Expanded(
                  child: CastListView(
                    controller: castListController,
                    filterProfile: AuthManager.instance.profile,
                    fullyInteractive: false,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            );
          }),
    );
  }
}

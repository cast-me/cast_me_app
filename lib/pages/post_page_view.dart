import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/async_submit_button.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/post_page/audio_recorder_recommender.dart';
import 'package:cast_me_app/widgets/post_page/reply_cast_selector.dart';
import 'package:cast_me_app/widgets/post_page/title_field.dart';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';

class PostPageView extends StatefulWidget {
  const PostPageView({Key? key}) : super(key: key);

  @override
  State<PostPageView> createState() => _PostPageViewState();
}

class _PostPageViewState extends State<PostPageView> {
  final ValueNotifier<String> titleText = ValueNotifier('');
  final CastListController castListController = CastListController();

  Key titleFieldKey = UniqueKey();

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
                    'You can select an audio file using the button below or '
                    'can use the share button in the app containing your audio '
                    'file (select CastMe as the app to share to).\n'
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
                  child: Text(
                    castFiles.isNotEmpty
                        ? castFiles.first.platformFile.name
                        : 'Select audio',
                  ),
                ),
                const ReplyCastSelector(),
                TitleField(
                  key: titleFieldKey,
                  titleText: titleText,
                ),
                ValueListenableBuilder<String>(
                  valueListenable: titleText,
                  builder: (context, title, _) {
                    return AsyncSubmitButton(
                      child: const Text('Submit'),
                      onPressed: castFiles.isNotEmpty && title.isNotEmpty
                          ? () async {
                              await CastDatabase.instance.createCast(
                                title: title,
                                castFile: castFiles.first,
                                replyTo: PostBloc.instance.replyCast.value,
                              );
                              // No need to call setState as updating the
                              // castFiles list in postBloc will do that.
                              castListController.refresh();
                              titleText.value = '';
                              // Gross hack to force the title field to
                              // rebuild from scratch.
                              titleFieldKey = UniqueKey();
                              PostBloc.instance.popFirstFile();
                              PostBloc.instance.replyCast.value = null;
                            }
                          : null,
                    );
                  },
                ),
                const AdaptiveText('Your casts'),
                const SizedBox(height: 4),
                Expanded(
                  child: CastViewTheme(
                    isInteractive: false,
                    hideDelete: false,
                    indentReplies: false,
                    child: CastListView(
                      controller: castListController,
                      filterProfile: AuthManager.instance.profile,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

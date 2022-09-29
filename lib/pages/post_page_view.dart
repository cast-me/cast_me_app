import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/async_submit_button.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/post_page/pick_file_view.dart';
import 'package:cast_me_app/widgets/post_page/post_help_tooltip.dart';
import 'package:cast_me_app/widgets/post_page/record/record_view.dart';
import 'package:cast_me_app/widgets/post_page/reply_cast_selector.dart';
import 'package:cast_me_app/widgets/post_page/title_field.dart';

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
                Row(
                  children: const [
                    PostHelpTooltip(),
                    SizedBox(width: 4),
                    AdaptiveText('Cast audio:'),
                  ],
                ),
                Container(
                  child: Row(
                    children: const [
                      Expanded(child: RecordView()),
                      SizedBox(width: 8),
                      Expanded(child: PickFileView()),
                    ],
                  ),
                ),
                _SelectedAudioView(castFiles: castFiles),
                const ReplyCastSelector(),
                const SizedBox(height: 8),
                const Text('Cast title'),
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

class _SelectedAudioView extends StatelessWidget {
  const _SelectedAudioView({
    Key? key,
    required this.castFiles,
  }) : super(key: key);

  final List<CastFile> castFiles;

  @override
  Widget build(BuildContext context) {
    if (castFiles.isEmpty) {
      return Container();
    }
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            PostBloc.instance.clearFiles();
          },
        ),
        Expanded(
          child: Text(castFiles.first.platformFile.name),
        ),
      ],
    );
  }
}

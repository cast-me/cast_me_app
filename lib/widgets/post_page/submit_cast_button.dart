// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/util/cast_me_modal.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/widgets/post_page/cast_posted_modal.dart';
import 'package:cast_me_app/widgets/post_page/external_link_field.dart';

class SubmitCastButton extends StatelessWidget {
  const SubmitCastButton({
    super.key,
    required this.reset,
  });

  final VoidCallback reset;

  @override
  Widget build(BuildContext context) {
    final PostBloc bloc = PostBloc.instance;
    return ValueListenableBuilder<Future<CastFile>?>(
      valueListenable: bloc.castFile,
      builder: (context, castFile, _) {
        return FutureBuilder<CastFile?>(
          future: castFile == null ? Future.value(null) : castFile,
          builder: (context, snap) {
            final CastFile? castFile = snap.data;
            return ValueListenableBuilder<bool>(
              valueListenable: bloc.externalLinkTextController.select(
                (c) => ExternalLinkField.isValid(c.text),
              ),
              builder: (context, linkIsValid, _) {
                return ValueListenableBuilder<String>(
                  valueListenable: bloc.titleText,
                  builder: (context, title, _) {
                    return AsyncElevatedButton(
                      action: 'Submit',
                      child: const Text('Submit'),
                      onTap: castFile != null && title.isNotEmpty && linkIsValid
                          ? () => onSubmit(
                                context: context,
                                title: title,
                                castFile: castFile,
                              )
                          : null,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> onSubmit({
    required BuildContext context,
    required String title,
    required CastFile castFile,
  }) async {
    final String castId = await PostBloc.instance.submitFile(
      title: title,
      url: PostBloc.instance.externalLinkTextController.text,
      castFile: castFile,
    );
    final Cast cast = await CastDatabase.instance.getCast(castId: castId);
    reset();
    CastMeModal.showMessage(
      context,
      CastPostedModal(cast: cast),
    );
  }
}

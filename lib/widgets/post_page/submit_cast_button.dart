// Flutter imports:
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/cast_me_modal.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/widgets/common/async_submit_button.dart';
import 'package:cast_me_app/widgets/post_page/cast_posted_modal.dart';
import 'package:cast_me_app/widgets/post_page/external_link_field.dart';

class SubmitCastButton extends StatelessWidget {
  const SubmitCastButton({
    Key? key,
    required this.reset,
  }) : super(key: key);

  final VoidCallback reset;

  @override
  Widget build(BuildContext context) {
    final PostBloc bloc = PostBloc.instance;
    return ValueListenableBuilder<CastFile?>(
        valueListenable: bloc.castFile,
        builder: (context, castFile, _) {
          return ValueListenableBuilder<bool>(
            valueListenable: bloc.externalLinkTextController.select(
              () {
                return ExternalLinkField.isValid(
                    bloc.externalLinkTextController.text);
              },
            ),
            builder: (context, linkIsValid, _) {
              return ValueListenableBuilder<String>(
                valueListenable: bloc.titleText,
                builder: (context, title, _) {
                  return AsyncSubmitButton(
                    child: const Text('Submit'),
                    onPressed:
                        castFile != null && title.isNotEmpty && linkIsValid
                            ? () async {
                                final String castId =
                                    await PostBloc.instance.submitFile(
                                  title: title,
                                  url: bloc.externalLinkTextController.text,
                                  castFile: castFile,
                                );
                                final Cast cast = await CastDatabase.instance
                                    .getCast(castId: castId);
                                reset();
                                CastMeModal.showMessage(
                                  context,
                                  CastPostedModal(cast: cast),
                                );
                              }
                            : null,
                  );
                },
              );
            },
          );
        });
  }
}

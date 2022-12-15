// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/for_you_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/horizontal_card_list.dart';

class FollowUpCard extends StatelessWidget {
  const FollowUpCard({
    super.key,
    this.padding,
  });

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Future<List<Cast>>>(
      valueListenable: ForYouBloc.instance.followUpCasts,
      builder: (context, casts, child) {
        return FutureBuilder<List<Cast>>(
          future: casts,
          builder: (context, snap) {
            if (snap.hasError) {
              return ErrorText(error: snap.error!);
            }
            if (!snap.hasData || snap.data!.isEmpty) {
              return Container();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HorizontalCardList(
                padding: padding,
                // Force the cast to handle it's padding internally.
                pagePadding: EdgeInsets.zero,
                headerText: 'Share or reply',
                pages: snap.data!.map(
                  (c) {
                    return CastViewTheme(
                      indentReplies: false,
                      child: CastPreview(
                        cast: c,
                        padding: padding,
                      ),
                    );
                  },
                ).toList(),
              ),
            );
          },
        );
      },
    );
  }
}

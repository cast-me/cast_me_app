import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/horizontal_card_list.dart';
import 'package:flutter/material.dart';

class ShareCard extends StatefulWidget {
  const ShareCard({
    super.key,
    this.pagePadding,
  });

  final EdgeInsets? pagePadding;

  @override
  State<ShareCard> createState() => _ShareCardState();
}

class _ShareCardState extends State<ShareCard> {
  final Future<List<Cast>> casts = CastDatabase.instance
      .getCasts(
        limit: 10,
        onlyViewed: true,
        filterOutProfile: AuthManager.instance.profile,
      )
      .toList();

  @override
  Widget build(BuildContext context) {
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
            padding: widget.pagePadding,
            headerText: 'Follow up',
            pages: snap.data!.map(
              (c) {
                return CastViewTheme(
                  indentReplies: false,
                  child: CastPreview(cast: c),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}

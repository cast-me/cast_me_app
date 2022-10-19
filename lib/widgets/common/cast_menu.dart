import 'dart:io' show Platform;

import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/clients/share_client.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/common/drop_down_menu.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CastMenu extends StatelessWidget {
  const CastMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch these here because we don't have a valid `context` from an
    // onPressed callback.
    final CastListController? castListViewController =
        CastListController.of(context);
    final Cast cast = CastProvider.of(context);
    return DropDownMenu(
      builder: (context, hideMenu) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MenuButton(
              icon: Icons.reply,
              text: 'reply',
              onTap: () async {
                hideMenu();
                PostBloc.instance.replyCast.value = cast;
                CastMeBloc.instance.onTabChanged(CastMeTab.post);
              },
            ),
            _MenuButton(
              icon: Platform.isIOS ? Icons.ios_share : Icons.share,
              text: 'share',
              onTap: () async {
                hideMenu();
                await ShareClient.instance.share(cast);
              },
            ),
            if (cast.authorId == AuthManager.instance.profile.id)
              _MenuButton(
                icon: Icons.delete,
                text: 'delete cast',
                onTap: () async {
                  hideMenu();
                  await CastDatabase.instance.deleteCast(cast: cast);
                  castListViewController?.refresh();
                },
              ),
          ],
        );
      },
      adaptiveBackgroundColor: AdaptiveColor.background,
      child: const Icon(Icons.more_vert),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final AsyncCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 4),
          AdaptiveText(text),
        ],
      ),
    );
  }
}

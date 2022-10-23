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
    final Cast cast = CastProvider.of(context).value;
    return DropDownMenu(
      child: const Icon(Icons.more_vert, color: Colors.white),
      adaptiveBackgroundColor: AdaptiveColor.background,
      builder: (context, hideMenu) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MenuButton(
              icon: Icons.person,
              text: 'view profile',
              onTap: () async {
                hideMenu();
                CastMeBloc.instance.onUsernameSelected(cast.authorUsername);
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
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Platform.isIOS ? Icons.ios_share : Icons.share),
      onPressed: () async {
        await ShareClient.instance.share(CastProvider.of(context).value);
      },
    );
  }
}

class ReplyButton extends StatelessWidget {
  const ReplyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.reply),
      onPressed: () {
        PostBloc.instance.replyCast.value = CastProvider.of(context).value;
        CastMeBloc.instance.onTabChanged(CastMeTab.post);
      },
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

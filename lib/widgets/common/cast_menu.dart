// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/clients/share_client.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/drop_down_menu.dart';
import 'package:cast_me_app/widgets/common/external_link_modal.dart';

class CastMenu extends StatelessWidget {
  const CastMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch these here because we don't have a valid `context` from an
    // onPressed callback.
    final CastMeListController<Cast>? listController =
        CastMeListController.of<Cast>(context);
    final Cast cast = CastProvider.of(context).value;
    return DropDownMenu(
      child: const Icon(Icons.more_vert, color: Colors.white),
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
                  listController?.refresh();
                },
              ),
            if (cast.externalUri != null)
              _MenuButton(
                icon: Icons.link,
                text: 'visit link',
                onTap: () async {
                  hideMenu();
                  ExternalLinkModal.showMessage(context, cast.externalUri!);
                },
              ),
          ],
        );
      },
    );
  }
}

class StackCastMenu extends StatelessWidget {
  const StackCastMenu({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (CastViewTheme.of(context)?.showMenu == false) {
      return child;
    }
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              ReplyButton(),
              ShareButton(),
              CastMenu(),
            ],
          ),
        ),
      ],
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
      // Don't let text button inject it's own theme.
      child: IconTheme(
        data: IconTheme.of(context),
        child: DefaultTextStyle(
          style: DefaultTextStyle.of(context).style,
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 4),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}

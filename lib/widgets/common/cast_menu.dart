// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:cast_me_app/business_logic/clients/social_manager.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/util/cast_me_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/clients/share_client.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/drop_down_menu.dart';
import 'package:cast_me_app/widgets/common/external_link_modal.dart';

class CastMenu extends StatelessWidget {
  const CastMenu({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Fetch these here because we don't have a valid `context` from an
    // onPressed callback.
    final CastMeListController<Cast>? listController =
        CastMeListController.of<Cast>(context);
    final Cast cast = CastProvider.of(context).value;
    return DropDownMenu(
      child: const Icon(Icons.more_vert),
      builder: (context, hideMenu) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MenuButton(
              icon: Icons.list,
              text: 'view thread',
              onTap: () async {
                hideMenu();
                onTap?.call();
                CastMeBloc.instance.onTabChanged(CastMeTab.listen);
                ListenBloc.instance.onConversationIdSelected(cast.rootId);
              },
            ),
            _MenuButton(
              icon: Icons.person,
              text: 'view profile',
              onTap: () async {
                hideMenu();
                onTap?.call();
                CastMeBloc.instance.onUsernameSelected(cast.authorUsername);
              },
            ),
            if (cast.authorId == AuthManager.instance.profile.id)
              _MenuButton(
                icon: Icons.delete,
                text: 'delete cast',
                onTap: () async {
                  hideMenu();
                  onTap?.call();
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
                  onTap?.call();
                  ExternalLinkModal.showMessage(context, cast.externalUri!);
                },
              ),
            if (cast.authorId != AuthManager.instance.profile.id)
              _MenuButton(
                icon: Icons.block,
                text: 'block user',
                onTap: () async {
                  hideMenu();
                  onTap?.call();
                  CastMeModal.showMessage(
                    context,
                    _BlockUserModal(userId: cast.authorId),
                  );
                  listController?.refresh();
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
        const Positioned.fill(
          child: CastButtonRow(),
        ),
      ],
    );
  }
}

class CastButtonRow extends StatelessWidget {
  const CastButtonRow({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ReplyButton(onTap: onTap),
        ShareButton(onTap: onTap),
        CastMenu(onTap: onTap),
      ],
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Platform.isIOS ? Icons.ios_share : Icons.share),
      onPressed: () async {
        onTap?.call();
        await ShareClient.instance.share(CastProvider.of(context).value);
      },
    );
  }
}

class ReplyButton extends StatelessWidget {
  const ReplyButton({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.reply),
      onPressed: () {
        onTap?.call();
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

class _BlockUserModal extends StatelessWidget {
  const _BlockUserModal({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    return AsyncActionWrapper(
      // Use the builder so that children can reference the action wrapper.
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Are you sure you want to block this user?\n'
            'Blocking a user hide their casts from you and disallows them from '
            'replying directly to your cast.\n'
            'Users who you\'ve blocked can still use and post to CastMe. If '
            'you believe this person is damaging the CastMe community, '
            'please report them in addition to blocking them.',
            textAlign: TextAlign.center,
          ),
          AsyncTextButton(
            text: 'block user',
            onTap: () async {
              await SocialManager.instance.blockUser(id: userId);
              Navigator.of(context).pop();
            },
          ),
          const AsyncErrorView(),
        ],
      ),
    );
  }
}

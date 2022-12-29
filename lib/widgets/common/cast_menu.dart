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
import 'package:cast_me_app/business_logic/clients/social_manager.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/util/cast_me_modal.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/drop_down_menu.dart';
import 'package:cast_me_app/widgets/common/external_link_modal.dart';

class StackCastMenu extends StatelessWidget {
  const StackCastMenu({super.key, required this.child});

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
          child: CastMenu(),
        ),
      ],
    );
  }
}

class CastMenu extends StatelessWidget {
  const CastMenu({
    super.key,
    this.onTap,
    this.wide = false,
  });

  final VoidCallback? onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    // Fetch these here because we may not have a valid `context` from an
    // onPressed callback.
    final CastMeListController<Cast>? listController =
        CastMeListController.of<Cast>(context);
    final Cast cast = CastProvider.of(context).value;
    final List<Widget> baseChildren = [
      const ReplyButton(),
      const ShareButton(),
    ];
    final List<Widget> wideChildren = [
      MenuButton(
        icon: Icons.list,
        text: 'view thread',
        onTap: () async {
          CastMeBloc.instance.onTabChanged(CastMeTab.listen);
          ListenBloc.instance.onConversationIdSelected(cast.rootId);
        },
      ),
      MenuButton(
        icon: Icons.person,
        text: 'view profile',
        onTap: () async {
          CastMeBloc.instance.onUsernameSelected(cast.authorUsername);
        },
      ),
      if (cast.authorId == AuthManager.instance.profile.id)
        MenuButton(
          icon: Icons.delete,
          text: 'delete cast',
          onTap: () async {
            await CastDatabase.instance.deleteCast(cast: cast);
            listController?.refresh();
          },
        ),
      if (cast.externalUri != null)
        MenuButton(
          icon: Icons.link,
          text: 'visit link',
          onTap: () async {
            ExternalLinkModal.showMessage(context, cast.externalUri!);
          },
        ),
    ];
    return _MenuButtonTheme(
      data: _MenuButtonThemeData(
        onTapSideEffect: onTap,
        showLabel: false,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...baseChildren,
          if (wide) ...wideChildren,
          CastMenuDropDown(
            children: [
              if (!wide) ...wideChildren,
              if (cast.authorId != AuthManager.instance.profile.id)
                MenuButton(
                  icon: Icons.block,
                  text: 'block user',
                  onTap: () async {
                    CastMeModal.showMessage(
                      context,
                      _BlockUserModal(userId: cast.authorId),
                    );
                    listController?.refresh();
                  },
                ),
              if (cast.authorId != AuthManager.instance.profile.id)
                MenuButton(
                  icon: Icons.report,
                  text: 'report cast',
                  onTap: () async {
                    CastMeModal.showMessage(
                      context,
                      _ReportCastModal(cast: cast),
                    );
                    listController?.refresh();
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class CastMenuDropDown extends StatelessWidget {
  const CastMenuDropDown({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? parentSideEffect =
        _MenuButtonTheme.of(context)?.onTapSideEffect;
    return DropDownMenu(
      child: const Icon(Icons.more_vert),
      builder: (context, hideMenu) {
        return _MenuButtonTheme(
          data: _MenuButtonThemeData(
            // Add an additional side effect.
            onTapSideEffect: () {
              hideMenu();
              parentSideEffect?.call();
            },
            showLabel: true,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        );
      },
    );
  }
}

class ReplyButton extends StatelessWidget {
  const ReplyButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MenuButton(
      icon: Icons.reply,
      text: 'reply',
      onTap: () async {
        PostBloc.instance.replyCast.value = CastProvider.of(context).value;
        CastMeBloc.instance.onTabChanged(CastMeTab.post);
      },
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    this.showLabel,
  });

  final bool? showLabel;

  @override
  Widget build(BuildContext context) {
    return MenuButton(
      showLabel: showLabel,
      icon: Platform.isIOS ? Icons.ios_share : Icons.share,
      text: 'share',
      onTap: () async {
        await ShareClient.instance.share(CastProvider.of(context).value);
      },
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    this.showLabel,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isEnabled = true,
  });

  final bool? showLabel;
  final IconData icon;
  final String text;
  final AsyncCallback onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final _MenuButtonThemeData? theme = _MenuButtonTheme.of(context);
    if (showLabel == false || theme?.showLabel == false) {
      return IconButton(
        icon: Icon(icon),
        onPressed: !isEnabled
            ? null
            : () {
                theme?.onTapSideEffect?.call();
                onTap();
              },
      );
    }
    return Opacity(
      opacity: isEnabled ? 1 : .5,
      child: TextButton(
        onPressed: !isEnabled
            ? null
            : () {
                theme?.onTapSideEffect?.call();
                onTap();
              },
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
      ),
    );
  }
}

class _BlockUserModal extends StatelessWidget {
  const _BlockUserModal({
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return AsyncActionWrapper(
      // Use the builder so that children can reference the action wrapper.
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Are you sure you want to block this user?\n\n'
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

class _ReportCastModal extends StatefulWidget {
  const _ReportCastModal({
    required this.cast,
  });

  final Cast cast;

  @override
  State<_ReportCastModal> createState() => _ReportCastModalState();
}

class _ReportCastModalState extends State<_ReportCastModal> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AsyncActionWrapper(
      // Use the builder so that children can reference the action wrapper.
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Are you sure you want to report this cast?\n'
            'You should report a cast if you think that it significantly '
            'degrades the CastMe community.\n'
            'Once you report a user CastMe staff will evaluate the content '
            'and respond (delete the cast, warn/ban the user, etc).',
            textAlign: TextAlign.center,
          ),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Reason for reporting',
            ),
          ),
          AsyncTextButton(
            text: 'report cast',
            onTap: () async {
              await SocialManager.instance.reportCast(
                cast: widget.cast,
                reason: controller.text,
              );
              Navigator.of(context).pop();
            },
          ),
          const AsyncErrorView(),
        ],
      ),
    );
  }
}

class _MenuButtonThemeData {
  _MenuButtonThemeData({
    required this.showLabel,
    this.onTapSideEffect,
  });

  final bool showLabel;

  /// Function to be called in addition to the button's on tap.
  final VoidCallback? onTapSideEffect;
}

class _MenuButtonTheme extends InheritedWidget {
  const _MenuButtonTheme({
    required super.child,
    required this.data,
  });

  final _MenuButtonThemeData data;

  static _MenuButtonThemeData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_MenuButtonTheme>()?.data;
  }

  @override
  bool updateShouldNotify(_MenuButtonTheme old) {
    return data.showLabel != old.data.showLabel ||
        data.onTapSideEffect != old.data.onTapSideEffect;
  }
}

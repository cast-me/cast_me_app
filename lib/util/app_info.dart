// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/custom_icons.dart';

class AppInfo extends StatefulWidget {
  const AppInfo({
    Key? key,
    this.showIcon = true,
  }) : super(key: key);

  final bool showIcon;

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  static final Future<PackageInfo> packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: packageInfo,
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final PackageInfo info = snapshot.data!;
        return DefaultTextStyle(
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          textAlign: TextAlign.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText('user_id: ${AuthManager.instance.profile.id}'),
              SelectableText('${info.appName}'
                  ' v${info.version}+${info.buildNumber}'),
              if (widget.showIcon)
                Icon(
                  CustomIcons.castMe,
                  color: Theme.of(context).colorScheme.onSecondary,
                  size: 50,
                ),
            ],
          ),
        );
      },
    );
  }
}

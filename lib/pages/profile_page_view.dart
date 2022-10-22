import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_submit_button_wrapper.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/profile_page/profile_view.dart';

import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CastMePage(
      headerText: 'Your Profile',
      child: Column(
        children: [
          Expanded(child: ProfileView(profile: AuthManager.instance.profile)),
          AuthSubmitButtonWrapper(
            child: ElevatedButton(
              onPressed: () async {
                await AuthManager.instance.signOut();
              },
              child: const Text('Sign out'),
            ),
          ),
          const _AppInfo(),
        ],
      ),
    );
  }
}

class _AppInfo extends StatefulWidget {
  const _AppInfo({Key? key}) : super(key: key);

  @override
  State<_AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<_AppInfo> {
  final Future<PackageInfo> packageInfo = PackageInfo.fromPlatform();

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
            ],
          ),
        );
      },
    );
  }
}

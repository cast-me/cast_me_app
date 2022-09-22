import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/auth_flow_page/auth_submit_button_wrapper.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:cast_me_app/widgets/common/profile_picture_view.dart';

import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Profile profile = AuthManager.instance.profile;
    return CastMePage(
      headerText: 'Profile',
      child: Column(
        children: [
          Row(
            children: [
              Center(
                child: ProfilePictureView(profile: profile),
              ),
              const SizedBox(width: 8),
              DefaultTextStyle(
                style: Theme.of(context).textTheme.headline6!,
                child: Column(
                  children: [
                    Center(child: Text('@${profile.username}')),
                    Center(child: Text(profile.displayName)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: AdaptiveText(
              'Your Casts:',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Expanded(
            child: CastListView(
              filterProfile: AuthManager.instance.profile,
              fullyInteractive: false,
            ),
          ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${info.appName}'),
              Text('v${info.version}+${info.buildNumber}'),
            ],
          ),
        );
      },
    );
  }
}

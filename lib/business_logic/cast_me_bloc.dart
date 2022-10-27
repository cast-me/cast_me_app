import 'package:cast_me_app/business_logic/clients/analytics.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';

import 'package:flutter/foundation.dart';

/// Contains the top level state for the CastMe App.
///
/// "BLoC" stands for "business logic component". This and other classes named
/// BLoC provide read-only app state to UI elements and expose
/// `on<state_variable>Changed` callbacks to change state in response to user
/// interactions (eg a button press).
///
/// All BLoC classes are singletons with private constructors. They are accessed
/// via `.instance`.
class CastMeBloc {
  CastMeBloc._();

  static final instance = CastMeBloc._();

  final ValueNotifier<SelectedProfile?> _selectedProfile = ValueNotifier(null);

  ValueListenable<SelectedProfile?> get selectedProfile => _selectedProfile;

  final ValueNotifier<CastMeTab> _currentTab = ValueNotifier(CastMeTab.listen);

  ValueListenable<CastMeTab> get currentTab => _currentTab;

  final ListenBloc listenBloc = ListenBloc.instance;

  final PostBloc postBloc = PostBloc.instance;

  void onTabIndexChanged(int newIndex) {
    onTabChanged(CastMeTabs.indexToTab(newIndex));
  }

  void onTabChanged(CastMeTab newTab) {
    if (newTab == _currentTab.value) {
      return;
    }
    Analytics.instance.logTabSelect(
      fromTab: _currentTab.value,
      toTab: newTab,
    );
    _currentTab.value = newTab;
  }

  void onProfileSelected(Profile? profile) {
    _onSelectedProfile(
      profile == null ? null : SelectedProfile.fromProfile(profile),
    );
  }

  void onUsernameSelected(String? username) {
    _onSelectedProfile(
      username == null ? null : SelectedProfile(username: username),
    );
  }

  void _onSelectedProfile(SelectedProfile? selection) {
    if (selection == null) {
      _selectedProfile.value = null;
      return;
    }
    if (AuthManager.instance.profile.username == selection.username) {
      // If we're jumping to our profile just go to the profile page instead.
      _selectedProfile.value = null;
      onTabChanged(CastMeTab.profile);
      return;
    }
    _selectedProfile.value = selection;
  }

  Future<void> onSharedFile(Iterable<String> filePaths) async {
    await postBloc.onFileSelected(filePaths.first);
    onTabChanged(_currentTab.value = CastMeTab.post);
  }

  // Called when an app link is received. For example, if the user clicks on a
  // CastMe share link.
  Future<void> onLinkPath(List<String> pathSegments) async {
    // TODO: add error reporting and better sanity checking here.
    if (pathSegments.length == 2 && pathSegments.last.length == 8) {
      // This is a potentially valid cast link.
      final String authorUsername = pathSegments[0];
      final String truncId = pathSegments[1];
      await ListenBloc.instance.onTruncatedCastIdSelected(
        authorUsername: authorUsername,
        truncId: truncId,
        autoPlay: true,
      );
    }
  }
}

class SelectedProfile {
  SelectedProfile({required this.username})
      : profile = AuthManager.instance.getProfile(username: username);

  SelectedProfile.fromProfile(Profile syncProfile)
      : profile = Future.value(syncProfile),
        username = syncProfile.username;

  String username;
  Future<Profile> profile;
}

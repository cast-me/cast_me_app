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
    if (newTab == CastMeTab.post) {
      // We shouldn't play a cast while the user is posting their own cast.
      CastAudioPlayer.instance.pause();
    }
    _currentTab.value = newTab;
  }

  void onUsernameSelected(String? newSelection) {
    if (newSelection == null) {
      _selectedProfile.value = null;
      return;
    }
    if (AuthManager.instance.profile.username == newSelection) {
      // If we're jumping to our profile just go to the profile page instead.
      _selectedProfile.value = null;
      onTabChanged(CastMeTab.profile);
      return;
    }
    _selectedProfile.value = SelectedProfile(username: newSelection);
  }

  Future<void> onSharedFile(Iterable<String> filePaths) async {
    await postBloc.onFilesSelected(filePaths);
    onTabChanged(_currentTab.value = CastMeTab.post);
  }
}

class SelectedProfile {
  SelectedProfile({required this.username})
      : profile = AuthManager.instance.getProfile(username: username);

  String username;
  Future<Profile> profile;
}

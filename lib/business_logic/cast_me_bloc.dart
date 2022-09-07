import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';

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

  final ValueNotifier<CastMeTab> currentTab = ValueNotifier(CastMeTab.listen);

  final ListenBloc listenBloc = ListenBloc.instance;
}

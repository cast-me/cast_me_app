import 'package:cast_me_app/mock_data.dart';
import 'package:cast_me_app/models/cast.dart';

import 'package:palette_generator/palette_generator.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CastMeModel {
  CastMeModel._();

  static final instance = CastMeModel._();

  final NowPlayingModel nowPlayingModel = NowPlayingModel._();
}

class NowPlayingModel {
  NowPlayingModel._();

  final ValueNotifier<Cast> _currentCast = ValueNotifier(ezraGunDeal);

  ValueListenable<Cast> get currentCast => _currentCast;

  void onCastChanged(Cast newCast) {
    _currentCast.value = newCast;
  }
}

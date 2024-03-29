// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/util/color_utils.dart';

part 'profile.freezed.dart';

part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  // flutter pub run build_runner build
  const factory Profile({
    required String id,
    required String username,
    required String displayName,
    required String? profilePictureUrl,
    required String? accentColorBase,
    required bool deleted,
  }) = _Profile;

  factory Profile.fromJson(Map<String, Object?> json) =>
      _$ProfileFromJson(json);
}

extension ProfileUtils on Profile {
  Color get accentColor =>
      ColorUtils.deserialize(accentColorBase ?? 'FFFFFFFF');

  bool get isComplete => displayName.isNotEmpty;

  // The auth-specific user data.
  User get authUser => supabase.auth.currentUser!;

  bool get isSelf => id == AuthManager.instance.user!.id;
}

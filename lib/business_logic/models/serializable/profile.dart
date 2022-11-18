// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/util/color_utils.dart';

part 'profile.freezed.dart';

part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String username,
    required String displayName,
    required String profilePictureUrl,
    required String? accentColorBase,
  }) = _Profile;

  const Profile._();

  factory Profile.fromJson(Map<String, Object?> json) =>
      _$ProfileFromJson(json);

  Color get accentColor =>
      ColorUtils.deserialize(accentColorBase ?? 'FFFFFFFF');

  bool get isComplete => displayName.isNotEmpty && profilePictureUrl.isNotEmpty;

  // The auth-specific user data.
  User get authUser => supabase.auth.currentUser!;
}

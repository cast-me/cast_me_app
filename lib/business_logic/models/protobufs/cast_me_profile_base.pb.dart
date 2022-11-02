///
//  Generated code. Do not modify.
//  source: business_logic/models/protobufs/cast_me_profile_base.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CastMeProfileBase extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CastMeProfileBase', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cast_me_app'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'displayName')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'profilePictureUrl')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accentColorBase')
    ..hasRequiredFields = false
  ;

  CastMeProfileBase._() : super();
  factory CastMeProfileBase({
    $core.String? id,
    $core.String? username,
    $core.String? displayName,
    $core.String? profilePictureUrl,
    $core.String? accentColorBase,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (username != null) {
      _result.username = username;
    }
    if (displayName != null) {
      _result.displayName = displayName;
    }
    if (profilePictureUrl != null) {
      _result.profilePictureUrl = profilePictureUrl;
    }
    if (accentColorBase != null) {
      _result.accentColorBase = accentColorBase;
    }
    return _result;
  }
  factory CastMeProfileBase.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CastMeProfileBase.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CastMeProfileBase clone() => CastMeProfileBase()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CastMeProfileBase copyWith(void Function(CastMeProfileBase) updates) => super.copyWith((message) => updates(message as CastMeProfileBase)) as CastMeProfileBase; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CastMeProfileBase create() => CastMeProfileBase._();
  CastMeProfileBase createEmptyInstance() => create();
  static $pb.PbList<CastMeProfileBase> createRepeated() => $pb.PbList<CastMeProfileBase>();
  @$core.pragma('dart2js:noInline')
  static CastMeProfileBase getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CastMeProfileBase>(create);
  static CastMeProfileBase? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get profilePictureUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set profilePictureUrl($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProfilePictureUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearProfilePictureUrl() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get accentColorBase => $_getSZ(4);
  @$pb.TagNumber(5)
  set accentColorBase($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAccentColorBase() => $_has(4);
  @$pb.TagNumber(5)
  void clearAccentColorBase() => clearField(5);
}


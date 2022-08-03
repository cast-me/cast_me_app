///
//  Generated code. Do not modify.
//  source: lib/business_logic/models/protobufs/cast_me_user_base.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CastMeUserBase extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CastMeUserBase', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cast_me_app'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userName')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'displayName')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'profilePictureUri')
    ..hasRequiredFields = false
  ;

  CastMeUserBase._() : super();
  factory CastMeUserBase({
    $core.String? uid,
    $core.String? userName,
    $core.String? displayName,
    $core.String? profilePictureUri,
  }) {
    final _result = create();
    if (uid != null) {
      _result.uid = uid;
    }
    if (userName != null) {
      _result.userName = userName;
    }
    if (displayName != null) {
      _result.displayName = displayName;
    }
    if (profilePictureUri != null) {
      _result.profilePictureUri = profilePictureUri;
    }
    return _result;
  }
  factory CastMeUserBase.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CastMeUserBase.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CastMeUserBase clone() => CastMeUserBase()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CastMeUserBase copyWith(void Function(CastMeUserBase) updates) => super.copyWith((message) => updates(message as CastMeUserBase)) as CastMeUserBase; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CastMeUserBase create() => CastMeUserBase._();
  CastMeUserBase createEmptyInstance() => create();
  static $pb.PbList<CastMeUserBase> createRepeated() => $pb.PbList<CastMeUserBase>();
  @$core.pragma('dart2js:noInline')
  static CastMeUserBase getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CastMeUserBase>(create);
  static CastMeUserBase? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userName => $_getSZ(1);
  @$pb.TagNumber(2)
  set userName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserName() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get profilePictureUri => $_getSZ(3);
  @$pb.TagNumber(4)
  set profilePictureUri($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProfilePictureUri() => $_has(3);
  @$pb.TagNumber(4)
  void clearProfilePictureUri() => clearField(4);
}


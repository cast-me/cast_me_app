///
//  Generated code. Do not modify.
//  source: business_logic/models/protobufs/like_base.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// Dart imports:
import 'dart:core' as $core;

// Package imports:
import 'package:protobuf/protobuf.dart' as $pb;

class LikeBase extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LikeBase', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cast_me_app'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAtString')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userDisplayName')
    ..hasRequiredFields = false
  ;

  LikeBase._() : super();
  factory LikeBase({
    $core.String? createdAtString,
    $core.String? userId,
    $core.String? userDisplayName,
  }) {
    final _result = create();
    if (createdAtString != null) {
      _result.createdAtString = createdAtString;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    if (userDisplayName != null) {
      _result.userDisplayName = userDisplayName;
    }
    return _result;
  }
  factory LikeBase.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LikeBase.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LikeBase clone() => LikeBase()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LikeBase copyWith(void Function(LikeBase) updates) => super.copyWith((message) => updates(message as LikeBase)) as LikeBase; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LikeBase create() => LikeBase._();
  LikeBase createEmptyInstance() => create();
  static $pb.PbList<LikeBase> createRepeated() => $pb.PbList<LikeBase>();
  @$core.pragma('dart2js:noInline')
  static LikeBase getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LikeBase>(create);
  static LikeBase? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get createdAtString => $_getSZ(0);
  @$pb.TagNumber(1)
  set createdAtString($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreatedAtString() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreatedAtString() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get userDisplayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set userDisplayName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUserDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserDisplayName() => clearField(3);
}


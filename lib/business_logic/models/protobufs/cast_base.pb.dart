///
//  Generated code. Do not modify.
//  source: lib/business_logic/models/protobufs/cast_base.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CastBase extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CastBase', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cast_me_app'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'authorId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'authorDisplayName')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'durationMs', $pb.PbFieldType.OU3)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioUriBase')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imageUriBase')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accentColorBase')
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'viewCount', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  CastBase._() : super();
  factory CastBase({
    $core.String? authorId,
    $core.String? authorDisplayName,
    $core.String? title,
    $core.int? durationMs,
    $core.String? audioUriBase,
    $core.String? imageUriBase,
    $core.String? accentColorBase,
    $core.int? viewCount,
  }) {
    final _result = create();
    if (authorId != null) {
      _result.authorId = authorId;
    }
    if (authorDisplayName != null) {
      _result.authorDisplayName = authorDisplayName;
    }
    if (title != null) {
      _result.title = title;
    }
    if (durationMs != null) {
      _result.durationMs = durationMs;
    }
    if (audioUriBase != null) {
      _result.audioUriBase = audioUriBase;
    }
    if (imageUriBase != null) {
      _result.imageUriBase = imageUriBase;
    }
    if (accentColorBase != null) {
      _result.accentColorBase = accentColorBase;
    }
    if (viewCount != null) {
      _result.viewCount = viewCount;
    }
    return _result;
  }
  factory CastBase.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CastBase.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CastBase clone() => CastBase()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CastBase copyWith(void Function(CastBase) updates) => super.copyWith((message) => updates(message as CastBase)) as CastBase; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CastBase create() => CastBase._();
  CastBase createEmptyInstance() => create();
  static $pb.PbList<CastBase> createRepeated() => $pb.PbList<CastBase>();
  @$core.pragma('dart2js:noInline')
  static CastBase getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CastBase>(create);
  static CastBase? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get authorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set authorId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAuthorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthorId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get authorDisplayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set authorDisplayName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthorDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthorDisplayName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get durationMs => $_getIZ(3);
  @$pb.TagNumber(4)
  set durationMs($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDurationMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearDurationMs() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get audioUriBase => $_getSZ(4);
  @$pb.TagNumber(5)
  set audioUriBase($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAudioUriBase() => $_has(4);
  @$pb.TagNumber(5)
  void clearAudioUriBase() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get imageUriBase => $_getSZ(5);
  @$pb.TagNumber(6)
  set imageUriBase($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasImageUriBase() => $_has(5);
  @$pb.TagNumber(6)
  void clearImageUriBase() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get accentColorBase => $_getSZ(6);
  @$pb.TagNumber(7)
  set accentColorBase($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAccentColorBase() => $_has(6);
  @$pb.TagNumber(7)
  void clearAccentColorBase() => clearField(7);

  @$pb.TagNumber(10)
  $core.int get viewCount => $_getIZ(7);
  @$pb.TagNumber(10)
  set viewCount($core.int v) { $_setUnsignedInt32(7, v); }
  @$pb.TagNumber(10)
  $core.bool hasViewCount() => $_has(7);
  @$pb.TagNumber(10)
  void clearViewCount() => clearField(10);
}


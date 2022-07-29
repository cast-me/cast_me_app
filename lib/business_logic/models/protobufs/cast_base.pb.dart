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
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'author')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'durationMs', $pb.PbFieldType.OU3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioUriBase')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imageUriBase')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accentColorBase')
    ..hasRequiredFields = false
  ;

  CastBase._() : super();
  factory CastBase({
    $core.String? author,
    $core.String? title,
    $core.int? durationMs,
    $core.String? audioUriBase,
    $core.String? imageUriBase,
    $core.String? accentColorBase,
  }) {
    final _result = create();
    if (author != null) {
      _result.author = author;
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
  $core.String get author => $_getSZ(0);
  @$pb.TagNumber(1)
  set author($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAuthor() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthor() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get durationMs => $_getIZ(2);
  @$pb.TagNumber(3)
  set durationMs($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDurationMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearDurationMs() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get audioUriBase => $_getSZ(3);
  @$pb.TagNumber(4)
  set audioUriBase($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAudioUriBase() => $_has(3);
  @$pb.TagNumber(4)
  void clearAudioUriBase() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get imageUriBase => $_getSZ(4);
  @$pb.TagNumber(5)
  set imageUriBase($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasImageUriBase() => $_has(4);
  @$pb.TagNumber(5)
  void clearImageUriBase() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get accentColorBase => $_getSZ(5);
  @$pb.TagNumber(6)
  set accentColorBase($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAccentColorBase() => $_has(5);
  @$pb.TagNumber(6)
  void clearAccentColorBase() => clearField(6);
}


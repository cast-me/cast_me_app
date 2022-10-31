///
//  Generated code. Do not modify.
//  source: business_logic/models/protobufs/topic_base.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TopicBase extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TopicBase', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cast_me_app'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'castId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..hasRequiredFields = false
  ;

  TopicBase._() : super();
  factory TopicBase({
    $core.String? castId,
    $core.String? name,
  }) {
    final _result = create();
    if (castId != null) {
      _result.castId = castId;
    }
    if (name != null) {
      _result.name = name;
    }
    return _result;
  }
  factory TopicBase.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TopicBase.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TopicBase clone() => TopicBase()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TopicBase copyWith(void Function(TopicBase) updates) => super.copyWith((message) => updates(message as TopicBase)) as TopicBase; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TopicBase create() => TopicBase._();
  TopicBase createEmptyInstance() => create();
  static $pb.PbList<TopicBase> createRepeated() => $pb.PbList<TopicBase>();
  @$core.pragma('dart2js:noInline')
  static TopicBase getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TopicBase>(create);
  static TopicBase? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get castId => $_getSZ(0);
  @$pb.TagNumber(1)
  set castId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCastId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCastId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}


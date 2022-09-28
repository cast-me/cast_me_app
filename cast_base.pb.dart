///
//  Generated code. Do not modify.
//  source: cast_base.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'like_base.pb.dart' as $0;

class CastBase extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CastBase', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'cast_me_app'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAtString')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'authorUsername')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'authorDisplayName')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imageUrl')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accentColorBase')
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'viewCount', $pb.PbFieldType.OU3)
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hasViewed')
    ..pc<$0.LikeBase>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'likes', $pb.PbFieldType.PM, subBuilder: $0.LikeBase.create)
    ..pPS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'taggedUsernames')
    ..aOS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'replyTo')
    ..aOS(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'authorId')
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..a<$core.int>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'durationMs', $pb.PbFieldType.OU3)
    ..aOS(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audioUrl')
    ..hasRequiredFields = false
  ;

  CastBase._() : super();
  factory CastBase({
    $core.String? id,
    $core.String? createdAtString,
    $core.String? authorUsername,
    $core.String? authorDisplayName,
    $core.String? imageUrl,
    $core.String? accentColorBase,
    $core.int? viewCount,
    $core.bool? hasViewed,
    $core.Iterable<$0.LikeBase>? likes,
    $core.Iterable<$core.String>? taggedUsernames,
    $core.String? replyTo,
    $core.String? authorId,
    $core.String? title,
    $core.int? durationMs,
    $core.String? audioUrl,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (createdAtString != null) {
      _result.createdAtString = createdAtString;
    }
    if (authorUsername != null) {
      _result.authorUsername = authorUsername;
    }
    if (authorDisplayName != null) {
      _result.authorDisplayName = authorDisplayName;
    }
    if (imageUrl != null) {
      _result.imageUrl = imageUrl;
    }
    if (accentColorBase != null) {
      _result.accentColorBase = accentColorBase;
    }
    if (viewCount != null) {
      _result.viewCount = viewCount;
    }
    if (hasViewed != null) {
      _result.hasViewed = hasViewed;
    }
    if (likes != null) {
      _result.likes.addAll(likes);
    }
    if (taggedUsernames != null) {
      _result.taggedUsernames.addAll(taggedUsernames);
    }
    if (replyTo != null) {
      _result.replyTo = replyTo;
    }
    if (authorId != null) {
      _result.authorId = authorId;
    }
    if (title != null) {
      _result.title = title;
    }
    if (durationMs != null) {
      _result.durationMs = durationMs;
    }
    if (audioUrl != null) {
      _result.audioUrl = audioUrl;
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
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get createdAtString => $_getSZ(1);
  @$pb.TagNumber(2)
  set createdAtString($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreatedAtString() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedAtString() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get authorUsername => $_getSZ(2);
  @$pb.TagNumber(3)
  set authorUsername($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuthorUsername() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthorUsername() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get authorDisplayName => $_getSZ(3);
  @$pb.TagNumber(4)
  set authorDisplayName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAuthorDisplayName() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthorDisplayName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get imageUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set imageUrl($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasImageUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearImageUrl() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get accentColorBase => $_getSZ(5);
  @$pb.TagNumber(6)
  set accentColorBase($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAccentColorBase() => $_has(5);
  @$pb.TagNumber(6)
  void clearAccentColorBase() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get viewCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set viewCount($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasViewCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearViewCount() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get hasViewed => $_getBF(7);
  @$pb.TagNumber(8)
  set hasViewed($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasHasViewed() => $_has(7);
  @$pb.TagNumber(8)
  void clearHasViewed() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<$0.LikeBase> get likes => $_getList(8);

  @$pb.TagNumber(10)
  $core.List<$core.String> get taggedUsernames => $_getList(9);

  @$pb.TagNumber(11)
  $core.String get replyTo => $_getSZ(10);
  @$pb.TagNumber(11)
  set replyTo($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasReplyTo() => $_has(10);
  @$pb.TagNumber(11)
  void clearReplyTo() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get authorId => $_getSZ(11);
  @$pb.TagNumber(12)
  set authorId($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasAuthorId() => $_has(11);
  @$pb.TagNumber(12)
  void clearAuthorId() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get title => $_getSZ(12);
  @$pb.TagNumber(13)
  set title($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasTitle() => $_has(12);
  @$pb.TagNumber(13)
  void clearTitle() => clearField(13);

  @$pb.TagNumber(14)
  $core.int get durationMs => $_getIZ(13);
  @$pb.TagNumber(14)
  set durationMs($core.int v) { $_setUnsignedInt32(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasDurationMs() => $_has(13);
  @$pb.TagNumber(14)
  void clearDurationMs() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get audioUrl => $_getSZ(14);
  @$pb.TagNumber(15)
  set audioUrl($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasAudioUrl() => $_has(14);
  @$pb.TagNumber(15)
  void clearAudioUrl() => clearField(15);
}


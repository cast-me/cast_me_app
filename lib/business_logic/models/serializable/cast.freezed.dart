// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'cast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Cast _$CastFromJson(Map<String, dynamic> json) {
  return _Cast.fromJson(json);
}

/// @nodoc
mixin _$Cast {
// Server specified.
  String get id => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  bool get deleted => throw _privateConstructorUsedError;
  bool get isPrivate =>
      throw _privateConstructorUsedError; // Fetched on read via join.
  String get rootId => throw _privateConstructorUsedError;
  String get authorUsername => throw _privateConstructorUsedError;
  String get authorDisplayName => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get accentColorBase => throw _privateConstructorUsedError;
  int get viewCount => throw _privateConstructorUsedError;
  bool get hasViewed => throw _privateConstructorUsedError;
  bool get treeHasNewCasts => throw _privateConstructorUsedError;
  List<Like>? get likes => throw _privateConstructorUsedError;
  List<String>? get visibleTo =>
      throw _privateConstructorUsedError; // We use names instead of a topic data model because we need to perform an
// array agg to filter and that only works with raw text values.
  List<String>? get topicNames => throw _privateConstructorUsedError;
  List<String>? get taggedUsernames =>
      throw _privateConstructorUsedError; // Client specified.
  String get authorId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  String get audioUrl => throw _privateConstructorUsedError;
  String? get replyTo => throw _privateConstructorUsedError;
  String? get externalUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CastCopyWith<Cast> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CastCopyWith<$Res> {
  factory $CastCopyWith(Cast value, $Res Function(Cast) then) =
      _$CastCopyWithImpl<$Res, Cast>;
  @useResult
  $Res call(
      {String id,
      String createdAt,
      bool deleted,
      bool isPrivate,
      String rootId,
      String authorUsername,
      String authorDisplayName,
      String? imageUrl,
      String? accentColorBase,
      int viewCount,
      bool hasViewed,
      bool treeHasNewCasts,
      List<Like>? likes,
      List<String>? visibleTo,
      List<String>? topicNames,
      List<String>? taggedUsernames,
      String authorId,
      String title,
      int durationMs,
      String audioUrl,
      String? replyTo,
      String? externalUrl});
}

/// @nodoc
class _$CastCopyWithImpl<$Res, $Val extends Cast>
    implements $CastCopyWith<$Res> {
  _$CastCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? deleted = null,
    Object? isPrivate = null,
    Object? rootId = null,
    Object? authorUsername = null,
    Object? authorDisplayName = null,
    Object? imageUrl = freezed,
    Object? accentColorBase = freezed,
    Object? viewCount = null,
    Object? hasViewed = null,
    Object? treeHasNewCasts = null,
    Object? likes = freezed,
    Object? visibleTo = freezed,
    Object? topicNames = freezed,
    Object? taggedUsernames = freezed,
    Object? authorId = null,
    Object? title = null,
    Object? durationMs = null,
    Object? audioUrl = null,
    Object? replyTo = freezed,
    Object? externalUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      rootId: null == rootId
          ? _value.rootId
          : rootId // ignore: cast_nullable_to_non_nullable
              as String,
      authorUsername: null == authorUsername
          ? _value.authorUsername
          : authorUsername // ignore: cast_nullable_to_non_nullable
              as String,
      authorDisplayName: null == authorDisplayName
          ? _value.authorDisplayName
          : authorDisplayName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      accentColorBase: freezed == accentColorBase
          ? _value.accentColorBase
          : accentColorBase // ignore: cast_nullable_to_non_nullable
              as String?,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasViewed: null == hasViewed
          ? _value.hasViewed
          : hasViewed // ignore: cast_nullable_to_non_nullable
              as bool,
      treeHasNewCasts: null == treeHasNewCasts
          ? _value.treeHasNewCasts
          : treeHasNewCasts // ignore: cast_nullable_to_non_nullable
              as bool,
      likes: freezed == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<Like>?,
      visibleTo: freezed == visibleTo
          ? _value.visibleTo
          : visibleTo // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      topicNames: freezed == topicNames
          ? _value.topicNames
          : topicNames // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      taggedUsernames: freezed == taggedUsernames
          ? _value.taggedUsernames
          : taggedUsernames // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      audioUrl: null == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String,
      replyTo: freezed == replyTo
          ? _value.replyTo
          : replyTo // ignore: cast_nullable_to_non_nullable
              as String?,
      externalUrl: freezed == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CastCopyWith<$Res> implements $CastCopyWith<$Res> {
  factory _$$_CastCopyWith(_$_Cast value, $Res Function(_$_Cast) then) =
      __$$_CastCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String createdAt,
      bool deleted,
      bool isPrivate,
      String rootId,
      String authorUsername,
      String authorDisplayName,
      String? imageUrl,
      String? accentColorBase,
      int viewCount,
      bool hasViewed,
      bool treeHasNewCasts,
      List<Like>? likes,
      List<String>? visibleTo,
      List<String>? topicNames,
      List<String>? taggedUsernames,
      String authorId,
      String title,
      int durationMs,
      String audioUrl,
      String? replyTo,
      String? externalUrl});
}

/// @nodoc
class __$$_CastCopyWithImpl<$Res> extends _$CastCopyWithImpl<$Res, _$_Cast>
    implements _$$_CastCopyWith<$Res> {
  __$$_CastCopyWithImpl(_$_Cast _value, $Res Function(_$_Cast) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? deleted = null,
    Object? isPrivate = null,
    Object? rootId = null,
    Object? authorUsername = null,
    Object? authorDisplayName = null,
    Object? imageUrl = freezed,
    Object? accentColorBase = freezed,
    Object? viewCount = null,
    Object? hasViewed = null,
    Object? treeHasNewCasts = null,
    Object? likes = freezed,
    Object? visibleTo = freezed,
    Object? topicNames = freezed,
    Object? taggedUsernames = freezed,
    Object? authorId = null,
    Object? title = null,
    Object? durationMs = null,
    Object? audioUrl = null,
    Object? replyTo = freezed,
    Object? externalUrl = freezed,
  }) {
    return _then(_$_Cast(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      rootId: null == rootId
          ? _value.rootId
          : rootId // ignore: cast_nullable_to_non_nullable
              as String,
      authorUsername: null == authorUsername
          ? _value.authorUsername
          : authorUsername // ignore: cast_nullable_to_non_nullable
              as String,
      authorDisplayName: null == authorDisplayName
          ? _value.authorDisplayName
          : authorDisplayName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      accentColorBase: freezed == accentColorBase
          ? _value.accentColorBase
          : accentColorBase // ignore: cast_nullable_to_non_nullable
              as String?,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasViewed: null == hasViewed
          ? _value.hasViewed
          : hasViewed // ignore: cast_nullable_to_non_nullable
              as bool,
      treeHasNewCasts: null == treeHasNewCasts
          ? _value.treeHasNewCasts
          : treeHasNewCasts // ignore: cast_nullable_to_non_nullable
              as bool,
      likes: freezed == likes
          ? _value._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<Like>?,
      visibleTo: freezed == visibleTo
          ? _value._visibleTo
          : visibleTo // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      topicNames: freezed == topicNames
          ? _value._topicNames
          : topicNames // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      taggedUsernames: freezed == taggedUsernames
          ? _value._taggedUsernames
          : taggedUsernames // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      audioUrl: null == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String,
      replyTo: freezed == replyTo
          ? _value.replyTo
          : replyTo // ignore: cast_nullable_to_non_nullable
              as String?,
      externalUrl: freezed == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Cast extends _Cast with DiagnosticableTreeMixin {
  const _$_Cast(
      {required this.id,
      required this.createdAt,
      required this.deleted,
      required this.isPrivate,
      required this.rootId,
      required this.authorUsername,
      required this.authorDisplayName,
      required this.imageUrl,
      required this.accentColorBase,
      required this.viewCount,
      required this.hasViewed,
      required this.treeHasNewCasts,
      required final List<Like>? likes,
      required final List<String>? visibleTo,
      required final List<String>? topicNames,
      required final List<String>? taggedUsernames,
      required this.authorId,
      required this.title,
      required this.durationMs,
      required this.audioUrl,
      required this.replyTo,
      required this.externalUrl})
      : _likes = likes,
        _visibleTo = visibleTo,
        _topicNames = topicNames,
        _taggedUsernames = taggedUsernames,
        super._();

  factory _$_Cast.fromJson(Map<String, dynamic> json) => _$$_CastFromJson(json);

// Server specified.
  @override
  final String id;
  @override
  final String createdAt;
  @override
  final bool deleted;
  @override
  final bool isPrivate;
// Fetched on read via join.
  @override
  final String rootId;
  @override
  final String authorUsername;
  @override
  final String authorDisplayName;
  @override
  final String? imageUrl;
  @override
  final String? accentColorBase;
  @override
  final int viewCount;
  @override
  final bool hasViewed;
  @override
  final bool treeHasNewCasts;
  final List<Like>? _likes;
  @override
  List<Like>? get likes {
    final value = _likes;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _visibleTo;
  @override
  List<String>? get visibleTo {
    final value = _visibleTo;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// We use names instead of a topic data model because we need to perform an
// array agg to filter and that only works with raw text values.
  final List<String>? _topicNames;
// We use names instead of a topic data model because we need to perform an
// array agg to filter and that only works with raw text values.
  @override
  List<String>? get topicNames {
    final value = _topicNames;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _taggedUsernames;
  @override
  List<String>? get taggedUsernames {
    final value = _taggedUsernames;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Client specified.
  @override
  final String authorId;
  @override
  final String title;
  @override
  final int durationMs;
  @override
  final String audioUrl;
  @override
  final String? replyTo;
  @override
  final String? externalUrl;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Cast(id: $id, createdAt: $createdAt, deleted: $deleted, isPrivate: $isPrivate, rootId: $rootId, authorUsername: $authorUsername, authorDisplayName: $authorDisplayName, imageUrl: $imageUrl, accentColorBase: $accentColorBase, viewCount: $viewCount, hasViewed: $hasViewed, treeHasNewCasts: $treeHasNewCasts, likes: $likes, visibleTo: $visibleTo, topicNames: $topicNames, taggedUsernames: $taggedUsernames, authorId: $authorId, title: $title, durationMs: $durationMs, audioUrl: $audioUrl, replyTo: $replyTo, externalUrl: $externalUrl)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Cast'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('deleted', deleted))
      ..add(DiagnosticsProperty('isPrivate', isPrivate))
      ..add(DiagnosticsProperty('rootId', rootId))
      ..add(DiagnosticsProperty('authorUsername', authorUsername))
      ..add(DiagnosticsProperty('authorDisplayName', authorDisplayName))
      ..add(DiagnosticsProperty('imageUrl', imageUrl))
      ..add(DiagnosticsProperty('accentColorBase', accentColorBase))
      ..add(DiagnosticsProperty('viewCount', viewCount))
      ..add(DiagnosticsProperty('hasViewed', hasViewed))
      ..add(DiagnosticsProperty('treeHasNewCasts', treeHasNewCasts))
      ..add(DiagnosticsProperty('likes', likes))
      ..add(DiagnosticsProperty('visibleTo', visibleTo))
      ..add(DiagnosticsProperty('topicNames', topicNames))
      ..add(DiagnosticsProperty('taggedUsernames', taggedUsernames))
      ..add(DiagnosticsProperty('authorId', authorId))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('durationMs', durationMs))
      ..add(DiagnosticsProperty('audioUrl', audioUrl))
      ..add(DiagnosticsProperty('replyTo', replyTo))
      ..add(DiagnosticsProperty('externalUrl', externalUrl));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Cast &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deleted, deleted) || other.deleted == deleted) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.rootId, rootId) || other.rootId == rootId) &&
            (identical(other.authorUsername, authorUsername) ||
                other.authorUsername == authorUsername) &&
            (identical(other.authorDisplayName, authorDisplayName) ||
                other.authorDisplayName == authorDisplayName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.accentColorBase, accentColorBase) ||
                other.accentColorBase == accentColorBase) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.hasViewed, hasViewed) ||
                other.hasViewed == hasViewed) &&
            (identical(other.treeHasNewCasts, treeHasNewCasts) ||
                other.treeHasNewCasts == treeHasNewCasts) &&
            const DeepCollectionEquality().equals(other._likes, _likes) &&
            const DeepCollectionEquality()
                .equals(other._visibleTo, _visibleTo) &&
            const DeepCollectionEquality()
                .equals(other._topicNames, _topicNames) &&
            const DeepCollectionEquality()
                .equals(other._taggedUsernames, _taggedUsernames) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl) &&
            (identical(other.replyTo, replyTo) || other.replyTo == replyTo) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        createdAt,
        deleted,
        isPrivate,
        rootId,
        authorUsername,
        authorDisplayName,
        imageUrl,
        accentColorBase,
        viewCount,
        hasViewed,
        treeHasNewCasts,
        const DeepCollectionEquality().hash(_likes),
        const DeepCollectionEquality().hash(_visibleTo),
        const DeepCollectionEquality().hash(_topicNames),
        const DeepCollectionEquality().hash(_taggedUsernames),
        authorId,
        title,
        durationMs,
        audioUrl,
        replyTo,
        externalUrl
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CastCopyWith<_$_Cast> get copyWith =>
      __$$_CastCopyWithImpl<_$_Cast>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CastToJson(
      this,
    );
  }
}

abstract class _Cast extends Cast {
  const factory _Cast(
      {required final String id,
      required final String createdAt,
      required final bool deleted,
      required final bool isPrivate,
      required final String rootId,
      required final String authorUsername,
      required final String authorDisplayName,
      required final String? imageUrl,
      required final String? accentColorBase,
      required final int viewCount,
      required final bool hasViewed,
      required final bool treeHasNewCasts,
      required final List<Like>? likes,
      required final List<String>? visibleTo,
      required final List<String>? topicNames,
      required final List<String>? taggedUsernames,
      required final String authorId,
      required final String title,
      required final int durationMs,
      required final String audioUrl,
      required final String? replyTo,
      required final String? externalUrl}) = _$_Cast;
  const _Cast._() : super._();

  factory _Cast.fromJson(Map<String, dynamic> json) = _$_Cast.fromJson;

  @override // Server specified.
  String get id;
  @override
  String get createdAt;
  @override
  bool get deleted;
  @override
  bool get isPrivate;
  @override // Fetched on read via join.
  String get rootId;
  @override
  String get authorUsername;
  @override
  String get authorDisplayName;
  @override
  String? get imageUrl;
  @override
  String? get accentColorBase;
  @override
  int get viewCount;
  @override
  bool get hasViewed;
  @override
  bool get treeHasNewCasts;
  @override
  List<Like>? get likes;
  @override
  List<String>? get visibleTo;
  @override // We use names instead of a topic data model because we need to perform an
// array agg to filter and that only works with raw text values.
  List<String>? get topicNames;
  @override
  List<String>? get taggedUsernames;
  @override // Client specified.
  String get authorId;
  @override
  String get title;
  @override
  int get durationMs;
  @override
  String get audioUrl;
  @override
  String? get replyTo;
  @override
  String? get externalUrl;
  @override
  @JsonKey(ignore: true)
  _$$_CastCopyWith<_$_Cast> get copyWith => throw _privateConstructorUsedError;
}

WriteCast _$WriteCastFromJson(Map<String, dynamic> json) {
  return _WriteCast.fromJson(json);
}

/// @nodoc
mixin _$WriteCast {
// Client specified.
  String get authorId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  String get audioUrl => throw _privateConstructorUsedError;
  String? get replyTo => throw _privateConstructorUsedError;
  String? get externalUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WriteCastCopyWith<WriteCast> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WriteCastCopyWith<$Res> {
  factory $WriteCastCopyWith(WriteCast value, $Res Function(WriteCast) then) =
      _$WriteCastCopyWithImpl<$Res, WriteCast>;
  @useResult
  $Res call(
      {String authorId,
      String title,
      int durationMs,
      String audioUrl,
      String? replyTo,
      String? externalUrl});
}

/// @nodoc
class _$WriteCastCopyWithImpl<$Res, $Val extends WriteCast>
    implements $WriteCastCopyWith<$Res> {
  _$WriteCastCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authorId = null,
    Object? title = null,
    Object? durationMs = null,
    Object? audioUrl = null,
    Object? replyTo = freezed,
    Object? externalUrl = freezed,
  }) {
    return _then(_value.copyWith(
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      audioUrl: null == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String,
      replyTo: freezed == replyTo
          ? _value.replyTo
          : replyTo // ignore: cast_nullable_to_non_nullable
              as String?,
      externalUrl: freezed == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_WriteCastCopyWith<$Res> implements $WriteCastCopyWith<$Res> {
  factory _$$_WriteCastCopyWith(
          _$_WriteCast value, $Res Function(_$_WriteCast) then) =
      __$$_WriteCastCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String authorId,
      String title,
      int durationMs,
      String audioUrl,
      String? replyTo,
      String? externalUrl});
}

/// @nodoc
class __$$_WriteCastCopyWithImpl<$Res>
    extends _$WriteCastCopyWithImpl<$Res, _$_WriteCast>
    implements _$$_WriteCastCopyWith<$Res> {
  __$$_WriteCastCopyWithImpl(
      _$_WriteCast _value, $Res Function(_$_WriteCast) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authorId = null,
    Object? title = null,
    Object? durationMs = null,
    Object? audioUrl = null,
    Object? replyTo = freezed,
    Object? externalUrl = freezed,
  }) {
    return _then(_$_WriteCast(
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      audioUrl: null == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String,
      replyTo: freezed == replyTo
          ? _value.replyTo
          : replyTo // ignore: cast_nullable_to_non_nullable
              as String?,
      externalUrl: freezed == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WriteCast with DiagnosticableTreeMixin implements _WriteCast {
  const _$_WriteCast(
      {required this.authorId,
      required this.title,
      required this.durationMs,
      required this.audioUrl,
      required this.replyTo,
      required this.externalUrl});

  factory _$_WriteCast.fromJson(Map<String, dynamic> json) =>
      _$$_WriteCastFromJson(json);

// Client specified.
  @override
  final String authorId;
  @override
  final String title;
  @override
  final int durationMs;
  @override
  final String audioUrl;
  @override
  final String? replyTo;
  @override
  final String? externalUrl;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WriteCast(authorId: $authorId, title: $title, durationMs: $durationMs, audioUrl: $audioUrl, replyTo: $replyTo, externalUrl: $externalUrl)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WriteCast'))
      ..add(DiagnosticsProperty('authorId', authorId))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('durationMs', durationMs))
      ..add(DiagnosticsProperty('audioUrl', audioUrl))
      ..add(DiagnosticsProperty('replyTo', replyTo))
      ..add(DiagnosticsProperty('externalUrl', externalUrl));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WriteCast &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl) &&
            (identical(other.replyTo, replyTo) || other.replyTo == replyTo) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, authorId, title, durationMs, audioUrl, replyTo, externalUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WriteCastCopyWith<_$_WriteCast> get copyWith =>
      __$$_WriteCastCopyWithImpl<_$_WriteCast>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WriteCastToJson(
      this,
    );
  }
}

abstract class _WriteCast implements WriteCast {
  const factory _WriteCast(
      {required final String authorId,
      required final String title,
      required final int durationMs,
      required final String audioUrl,
      required final String? replyTo,
      required final String? externalUrl}) = _$_WriteCast;

  factory _WriteCast.fromJson(Map<String, dynamic> json) =
      _$_WriteCast.fromJson;

  @override // Client specified.
  String get authorId;
  @override
  String get title;
  @override
  int get durationMs;
  @override
  String get audioUrl;
  @override
  String? get replyTo;
  @override
  String? get externalUrl;
  @override
  @JsonKey(ignore: true)
  _$$_WriteCastCopyWith<_$_WriteCast> get copyWith =>
      throw _privateConstructorUsedError;
}

Like _$LikeFromJson(Map<String, dynamic> json) {
  return _Like.fromJson(json);
}

/// @nodoc
mixin _$Like {
// Server specified.
  String get createdAt => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError; // Fetched on read.
  String get userDisplayName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LikeCopyWith<Like> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LikeCopyWith<$Res> {
  factory $LikeCopyWith(Like value, $Res Function(Like) then) =
      _$LikeCopyWithImpl<$Res, Like>;
  @useResult
  $Res call({String createdAt, String userId, String userDisplayName});
}

/// @nodoc
class _$LikeCopyWithImpl<$Res, $Val extends Like>
    implements $LikeCopyWith<$Res> {
  _$LikeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? userId = null,
    Object? userDisplayName = null,
  }) {
    return _then(_value.copyWith(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userDisplayName: null == userDisplayName
          ? _value.userDisplayName
          : userDisplayName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LikeCopyWith<$Res> implements $LikeCopyWith<$Res> {
  factory _$$_LikeCopyWith(_$_Like value, $Res Function(_$_Like) then) =
      __$$_LikeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String createdAt, String userId, String userDisplayName});
}

/// @nodoc
class __$$_LikeCopyWithImpl<$Res> extends _$LikeCopyWithImpl<$Res, _$_Like>
    implements _$$_LikeCopyWith<$Res> {
  __$$_LikeCopyWithImpl(_$_Like _value, $Res Function(_$_Like) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? userId = null,
    Object? userDisplayName = null,
  }) {
    return _then(_$_Like(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userDisplayName: null == userDisplayName
          ? _value.userDisplayName
          : userDisplayName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Like extends _Like with DiagnosticableTreeMixin {
  const _$_Like(
      {required this.createdAt,
      required this.userId,
      required this.userDisplayName})
      : super._();

  factory _$_Like.fromJson(Map<String, dynamic> json) => _$$_LikeFromJson(json);

// Server specified.
  @override
  final String createdAt;
  @override
  final String userId;
// Fetched on read.
  @override
  final String userDisplayName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Like(createdAt: $createdAt, userId: $userId, userDisplayName: $userDisplayName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Like'))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('userDisplayName', userDisplayName));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Like &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userDisplayName, userDisplayName) ||
                other.userDisplayName == userDisplayName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, createdAt, userId, userDisplayName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LikeCopyWith<_$_Like> get copyWith =>
      __$$_LikeCopyWithImpl<_$_Like>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LikeToJson(
      this,
    );
  }
}

abstract class _Like extends Like {
  const factory _Like(
      {required final String createdAt,
      required final String userId,
      required final String userDisplayName}) = _$_Like;
  const _Like._() : super._();

  factory _Like.fromJson(Map<String, dynamic> json) = _$_Like.fromJson;

  @override // Server specified.
  String get createdAt;
  @override
  String get userId;
  @override // Fetched on read.
  String get userDisplayName;
  @override
  @JsonKey(ignore: true)
  _$$_LikeCopyWith<_$_Like> get copyWith => throw _privateConstructorUsedError;
}

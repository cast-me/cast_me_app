// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
// Server specified.
  String get rootId => throw _privateConstructorUsedError;
  Cast get rootCast => throw _privateConstructorUsedError;
  List<Cast>? get casts => throw _privateConstructorUsedError;
  List<String>? get topics => throw _privateConstructorUsedError;
  int get castCount => throw _privateConstructorUsedError;
  int get newCastCount => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  List<String>? get visibleTo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) then) =
      _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call(
      {String rootId,
      Cast rootCast,
      List<Cast>? casts,
      List<String>? topics,
      int castCount,
      int newCastCount,
      bool isPrivate,
      List<String>? visibleTo});

  $CastCopyWith<$Res> get rootCast;
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rootId = null,
    Object? rootCast = null,
    Object? casts = freezed,
    Object? topics = freezed,
    Object? castCount = null,
    Object? newCastCount = null,
    Object? isPrivate = null,
    Object? visibleTo = freezed,
  }) {
    return _then(_value.copyWith(
      rootId: null == rootId
          ? _value.rootId
          : rootId // ignore: cast_nullable_to_non_nullable
              as String,
      rootCast: null == rootCast
          ? _value.rootCast
          : rootCast // ignore: cast_nullable_to_non_nullable
              as Cast,
      casts: freezed == casts
          ? _value.casts
          : casts // ignore: cast_nullable_to_non_nullable
              as List<Cast>?,
      topics: freezed == topics
          ? _value.topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      castCount: null == castCount
          ? _value.castCount
          : castCount // ignore: cast_nullable_to_non_nullable
              as int,
      newCastCount: null == newCastCount
          ? _value.newCastCount
          : newCastCount // ignore: cast_nullable_to_non_nullable
              as int,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      visibleTo: freezed == visibleTo
          ? _value.visibleTo
          : visibleTo // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CastCopyWith<$Res> get rootCast {
    return $CastCopyWith<$Res>(_value.rootCast, (value) {
      return _then(_value.copyWith(rootCast: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ConversationCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$_ConversationCopyWith(
          _$_Conversation value, $Res Function(_$_Conversation) then) =
      __$$_ConversationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String rootId,
      Cast rootCast,
      List<Cast>? casts,
      List<String>? topics,
      int castCount,
      int newCastCount,
      bool isPrivate,
      List<String>? visibleTo});

  @override
  $CastCopyWith<$Res> get rootCast;
}

/// @nodoc
class __$$_ConversationCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$_Conversation>
    implements _$$_ConversationCopyWith<$Res> {
  __$$_ConversationCopyWithImpl(
      _$_Conversation _value, $Res Function(_$_Conversation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rootId = null,
    Object? rootCast = null,
    Object? casts = freezed,
    Object? topics = freezed,
    Object? castCount = null,
    Object? newCastCount = null,
    Object? isPrivate = null,
    Object? visibleTo = freezed,
  }) {
    return _then(_$_Conversation(
      rootId: null == rootId
          ? _value.rootId
          : rootId // ignore: cast_nullable_to_non_nullable
              as String,
      rootCast: null == rootCast
          ? _value.rootCast
          : rootCast // ignore: cast_nullable_to_non_nullable
              as Cast,
      casts: freezed == casts
          ? _value._casts
          : casts // ignore: cast_nullable_to_non_nullable
              as List<Cast>?,
      topics: freezed == topics
          ? _value._topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      castCount: null == castCount
          ? _value.castCount
          : castCount // ignore: cast_nullable_to_non_nullable
              as int,
      newCastCount: null == newCastCount
          ? _value.newCastCount
          : newCastCount // ignore: cast_nullable_to_non_nullable
              as int,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      visibleTo: freezed == visibleTo
          ? _value._visibleTo
          : visibleTo // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Conversation extends _Conversation {
  const _$_Conversation(
      {required this.rootId,
      required this.rootCast,
      required final List<Cast>? casts,
      required final List<String>? topics,
      required this.castCount,
      required this.newCastCount,
      required this.isPrivate,
      required final List<String>? visibleTo})
      : _casts = casts,
        _topics = topics,
        _visibleTo = visibleTo,
        super._();

  factory _$_Conversation.fromJson(Map<String, dynamic> json) =>
      _$$_ConversationFromJson(json);

// Server specified.
  @override
  final String rootId;
  @override
  final Cast rootCast;
  final List<Cast>? _casts;
  @override
  List<Cast>? get casts {
    final value = _casts;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _topics;
  @override
  List<String>? get topics {
    final value = _topics;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int castCount;
  @override
  final int newCastCount;
  @override
  final bool isPrivate;
  final List<String>? _visibleTo;
  @override
  List<String>? get visibleTo {
    final value = _visibleTo;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Conversation(rootId: $rootId, rootCast: $rootCast, casts: $casts, topics: $topics, castCount: $castCount, newCastCount: $newCastCount, isPrivate: $isPrivate, visibleTo: $visibleTo)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Conversation &&
            (identical(other.rootId, rootId) || other.rootId == rootId) &&
            (identical(other.rootCast, rootCast) ||
                other.rootCast == rootCast) &&
            const DeepCollectionEquality().equals(other._casts, _casts) &&
            const DeepCollectionEquality().equals(other._topics, _topics) &&
            (identical(other.castCount, castCount) ||
                other.castCount == castCount) &&
            (identical(other.newCastCount, newCastCount) ||
                other.newCastCount == newCastCount) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            const DeepCollectionEquality()
                .equals(other._visibleTo, _visibleTo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      rootId,
      rootCast,
      const DeepCollectionEquality().hash(_casts),
      const DeepCollectionEquality().hash(_topics),
      castCount,
      newCastCount,
      isPrivate,
      const DeepCollectionEquality().hash(_visibleTo));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ConversationCopyWith<_$_Conversation> get copyWith =>
      __$$_ConversationCopyWithImpl<_$_Conversation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ConversationToJson(
      this,
    );
  }
}

abstract class _Conversation extends Conversation {
  const factory _Conversation(
      {required final String rootId,
      required final Cast rootCast,
      required final List<Cast>? casts,
      required final List<String>? topics,
      required final int castCount,
      required final int newCastCount,
      required final bool isPrivate,
      required final List<String>? visibleTo}) = _$_Conversation;
  const _Conversation._() : super._();

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$_Conversation.fromJson;

  @override // Server specified.
  String get rootId;
  @override
  Cast get rootCast;
  @override
  List<Cast>? get casts;
  @override
  List<String>? get topics;
  @override
  int get castCount;
  @override
  int get newCastCount;
  @override
  bool get isPrivate;
  @override
  List<String>? get visibleTo;
  @override
  @JsonKey(ignore: true)
  _$$_ConversationCopyWith<_$_Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

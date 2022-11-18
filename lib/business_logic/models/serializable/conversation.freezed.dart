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
  List<Cast> get casts => throw _privateConstructorUsedError;

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
  $Res call({String rootId, Cast rootCast, List<Cast> casts});

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
    Object? casts = null,
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
      casts: null == casts
          ? _value.casts
          : casts // ignore: cast_nullable_to_non_nullable
              as List<Cast>,
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
  $Res call({String rootId, Cast rootCast, List<Cast> casts});

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
    Object? casts = null,
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
      casts: null == casts
          ? _value._casts
          : casts // ignore: cast_nullable_to_non_nullable
              as List<Cast>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Conversation implements _Conversation {
  const _$_Conversation(
      {required this.rootId,
      required this.rootCast,
      required final List<Cast> casts})
      : _casts = casts;

  factory _$_Conversation.fromJson(Map<String, dynamic> json) =>
      _$$_ConversationFromJson(json);

// Server specified.
  @override
  final String rootId;
  @override
  final Cast rootCast;
  final List<Cast> _casts;
  @override
  List<Cast> get casts {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_casts);
  }

  @override
  String toString() {
    return 'Conversation(rootId: $rootId, rootCast: $rootCast, casts: $casts)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Conversation &&
            (identical(other.rootId, rootId) || other.rootId == rootId) &&
            (identical(other.rootCast, rootCast) ||
                other.rootCast == rootCast) &&
            const DeepCollectionEquality().equals(other._casts, _casts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, rootId, rootCast,
      const DeepCollectionEquality().hash(_casts));

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

abstract class _Conversation implements Conversation {
  const factory _Conversation(
      {required final String rootId,
      required final Cast rootCast,
      required final List<Cast> casts}) = _$_Conversation;

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$_Conversation.fromJson;

  @override // Server specified.
  String get rootId;
  @override
  Cast get rootCast;
  @override
  List<Cast> get casts;
  @override
  @JsonKey(ignore: true)
  _$$_ConversationCopyWith<_$_Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

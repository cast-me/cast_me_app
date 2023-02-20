// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reply_notification_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ReplyNotificationData _$ReplyNotificationDataFromJson(
    Map<String, dynamic> json) {
  return _ReplyNotificationData.fromJson(json);
}

/// @nodoc
mixin _$ReplyNotificationData {
  Cast get originalCast => throw _privateConstructorUsedError;
  Cast get replyCast => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReplyNotificationDataCopyWith<ReplyNotificationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReplyNotificationDataCopyWith<$Res> {
  factory $ReplyNotificationDataCopyWith(ReplyNotificationData value,
          $Res Function(ReplyNotificationData) then) =
      _$ReplyNotificationDataCopyWithImpl<$Res, ReplyNotificationData>;
  @useResult
  $Res call({Cast originalCast, Cast replyCast});

  $CastCopyWith<$Res> get originalCast;
  $CastCopyWith<$Res> get replyCast;
}

/// @nodoc
class _$ReplyNotificationDataCopyWithImpl<$Res,
        $Val extends ReplyNotificationData>
    implements $ReplyNotificationDataCopyWith<$Res> {
  _$ReplyNotificationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalCast = null,
    Object? replyCast = null,
  }) {
    return _then(_value.copyWith(
      originalCast: null == originalCast
          ? _value.originalCast
          : originalCast // ignore: cast_nullable_to_non_nullable
              as Cast,
      replyCast: null == replyCast
          ? _value.replyCast
          : replyCast // ignore: cast_nullable_to_non_nullable
              as Cast,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CastCopyWith<$Res> get originalCast {
    return $CastCopyWith<$Res>(_value.originalCast, (value) {
      return _then(_value.copyWith(originalCast: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CastCopyWith<$Res> get replyCast {
    return $CastCopyWith<$Res>(_value.replyCast, (value) {
      return _then(_value.copyWith(replyCast: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ReplyNotificationDataCopyWith<$Res>
    implements $ReplyNotificationDataCopyWith<$Res> {
  factory _$$_ReplyNotificationDataCopyWith(_$_ReplyNotificationData value,
          $Res Function(_$_ReplyNotificationData) then) =
      __$$_ReplyNotificationDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Cast originalCast, Cast replyCast});

  @override
  $CastCopyWith<$Res> get originalCast;
  @override
  $CastCopyWith<$Res> get replyCast;
}

/// @nodoc
class __$$_ReplyNotificationDataCopyWithImpl<$Res>
    extends _$ReplyNotificationDataCopyWithImpl<$Res, _$_ReplyNotificationData>
    implements _$$_ReplyNotificationDataCopyWith<$Res> {
  __$$_ReplyNotificationDataCopyWithImpl(_$_ReplyNotificationData _value,
      $Res Function(_$_ReplyNotificationData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalCast = null,
    Object? replyCast = null,
  }) {
    return _then(_$_ReplyNotificationData(
      originalCast: null == originalCast
          ? _value.originalCast
          : originalCast // ignore: cast_nullable_to_non_nullable
              as Cast,
      replyCast: null == replyCast
          ? _value.replyCast
          : replyCast // ignore: cast_nullable_to_non_nullable
              as Cast,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ReplyNotificationData extends _ReplyNotificationData {
  const _$_ReplyNotificationData(
      {required this.originalCast, required this.replyCast})
      : super._();

  factory _$_ReplyNotificationData.fromJson(Map<String, dynamic> json) =>
      _$$_ReplyNotificationDataFromJson(json);

  @override
  final Cast originalCast;
  @override
  final Cast replyCast;

  @override
  String toString() {
    return 'ReplyNotificationData(originalCast: $originalCast, replyCast: $replyCast)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ReplyNotificationData &&
            (identical(other.originalCast, originalCast) ||
                other.originalCast == originalCast) &&
            (identical(other.replyCast, replyCast) ||
                other.replyCast == replyCast));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, originalCast, replyCast);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ReplyNotificationDataCopyWith<_$_ReplyNotificationData> get copyWith =>
      __$$_ReplyNotificationDataCopyWithImpl<_$_ReplyNotificationData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ReplyNotificationDataToJson(
      this,
    );
  }
}

abstract class _ReplyNotificationData extends ReplyNotificationData {
  const factory _ReplyNotificationData(
      {required final Cast originalCast,
      required final Cast replyCast}) = _$_ReplyNotificationData;
  const _ReplyNotificationData._() : super._();

  factory _ReplyNotificationData.fromJson(Map<String, dynamic> json) =
      _$_ReplyNotificationData.fromJson;

  @override
  Cast get originalCast;
  @override
  Cast get replyCast;
  @override
  @JsonKey(ignore: true)
  _$$_ReplyNotificationDataCopyWith<_$_ReplyNotificationData> get copyWith =>
      throw _privateConstructorUsedError;
}

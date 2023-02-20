// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BaseNotification _$BaseNotificationFromJson(Map<String, dynamic> json) {
  return _BaseNotification.fromJson(json);
}

/// @nodoc
mixin _$BaseNotification {
  String get id => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get typeId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get read =>
      throw _privateConstructorUsedError; // This is a json blob representing the notification-specific data.
  Map<String, Object?> get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BaseNotificationCopyWith<BaseNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseNotificationCopyWith<$Res> {
  factory $BaseNotificationCopyWith(
          BaseNotification value, $Res Function(BaseNotification) then) =
      _$BaseNotificationCopyWithImpl<$Res, BaseNotification>;
  @useResult
  $Res call(
      {String id,
      String createdAt,
      String userId,
      String typeId,
      String title,
      bool read,
      Map<String, Object?> data});
}

/// @nodoc
class _$BaseNotificationCopyWithImpl<$Res, $Val extends BaseNotification>
    implements $BaseNotificationCopyWith<$Res> {
  _$BaseNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? userId = null,
    Object? typeId = null,
    Object? title = null,
    Object? read = null,
    Object? data = null,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      typeId: null == typeId
          ? _value.typeId
          : typeId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BaseNotificationCopyWith<$Res>
    implements $BaseNotificationCopyWith<$Res> {
  factory _$$_BaseNotificationCopyWith(
          _$_BaseNotification value, $Res Function(_$_BaseNotification) then) =
      __$$_BaseNotificationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String createdAt,
      String userId,
      String typeId,
      String title,
      bool read,
      Map<String, Object?> data});
}

/// @nodoc
class __$$_BaseNotificationCopyWithImpl<$Res>
    extends _$BaseNotificationCopyWithImpl<$Res, _$_BaseNotification>
    implements _$$_BaseNotificationCopyWith<$Res> {
  __$$_BaseNotificationCopyWithImpl(
      _$_BaseNotification _value, $Res Function(_$_BaseNotification) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? userId = null,
    Object? typeId = null,
    Object? title = null,
    Object? read = null,
    Object? data = null,
  }) {
    return _then(_$_BaseNotification(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      typeId: null == typeId
          ? _value.typeId
          : typeId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BaseNotification extends _BaseNotification {
  const _$_BaseNotification(
      {required this.id,
      required this.createdAt,
      required this.userId,
      required this.typeId,
      required this.title,
      required this.read,
      required final Map<String, Object?> data})
      : _data = data,
        super._();

  factory _$_BaseNotification.fromJson(Map<String, dynamic> json) =>
      _$$_BaseNotificationFromJson(json);

  @override
  final String id;
  @override
  final String createdAt;
  @override
  final String userId;
  @override
  final String typeId;
  @override
  final String title;
  @override
  final bool read;
// This is a json blob representing the notification-specific data.
  final Map<String, Object?> _data;
// This is a json blob representing the notification-specific data.
  @override
  Map<String, Object?> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'BaseNotification(id: $id, createdAt: $createdAt, userId: $userId, typeId: $typeId, title: $title, read: $read, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BaseNotification &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.typeId, typeId) || other.typeId == typeId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.read, read) || other.read == read) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, userId, typeId,
      title, read, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BaseNotificationCopyWith<_$_BaseNotification> get copyWith =>
      __$$_BaseNotificationCopyWithImpl<_$_BaseNotification>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BaseNotificationToJson(
      this,
    );
  }
}

abstract class _BaseNotification extends BaseNotification {
  const factory _BaseNotification(
      {required final String id,
      required final String createdAt,
      required final String userId,
      required final String typeId,
      required final String title,
      required final bool read,
      required final Map<String, Object?> data}) = _$_BaseNotification;
  const _BaseNotification._() : super._();

  factory _BaseNotification.fromJson(Map<String, dynamic> json) =
      _$_BaseNotification.fromJson;

  @override
  String get id;
  @override
  String get createdAt;
  @override
  String get userId;
  @override
  String get typeId;
  @override
  String get title;
  @override
  bool get read;
  @override // This is a json blob representing the notification-specific data.
  Map<String, Object?> get data;
  @override
  @JsonKey(ignore: true)
  _$$_BaseNotificationCopyWith<_$_BaseNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

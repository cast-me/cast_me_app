// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

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

LikeNotificationData _$LikeNotificationDataFromJson(Map<String, dynamic> json) {
  return _LikeNotificationData.fromJson(json);
}

/// @nodoc
mixin _$LikeNotificationData {
  Profile get profile => throw _privateConstructorUsedError;
  Cast get cast => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LikeNotificationDataCopyWith<LikeNotificationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LikeNotificationDataCopyWith<$Res> {
  factory $LikeNotificationDataCopyWith(LikeNotificationData value,
          $Res Function(LikeNotificationData) then) =
      _$LikeNotificationDataCopyWithImpl<$Res, LikeNotificationData>;
  @useResult
  $Res call({Profile profile, Cast cast});

  $ProfileCopyWith<$Res> get profile;
  $CastCopyWith<$Res> get cast;
}

/// @nodoc
class _$LikeNotificationDataCopyWithImpl<$Res,
        $Val extends LikeNotificationData>
    implements $LikeNotificationDataCopyWith<$Res> {
  _$LikeNotificationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = null,
    Object? cast = null,
  }) {
    return _then(_value.copyWith(
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile,
      cast: null == cast
          ? _value.cast
          : cast // ignore: cast_nullable_to_non_nullable
              as Cast,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res> get profile {
    return $ProfileCopyWith<$Res>(_value.profile, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CastCopyWith<$Res> get cast {
    return $CastCopyWith<$Res>(_value.cast, (value) {
      return _then(_value.copyWith(cast: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LikeNotificationDataCopyWith<$Res>
    implements $LikeNotificationDataCopyWith<$Res> {
  factory _$$_LikeNotificationDataCopyWith(_$_LikeNotificationData value,
          $Res Function(_$_LikeNotificationData) then) =
      __$$_LikeNotificationDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Profile profile, Cast cast});

  @override
  $ProfileCopyWith<$Res> get profile;
  @override
  $CastCopyWith<$Res> get cast;
}

/// @nodoc
class __$$_LikeNotificationDataCopyWithImpl<$Res>
    extends _$LikeNotificationDataCopyWithImpl<$Res, _$_LikeNotificationData>
    implements _$$_LikeNotificationDataCopyWith<$Res> {
  __$$_LikeNotificationDataCopyWithImpl(_$_LikeNotificationData _value,
      $Res Function(_$_LikeNotificationData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = null,
    Object? cast = null,
  }) {
    return _then(_$_LikeNotificationData(
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile,
      cast: null == cast
          ? _value.cast
          : cast // ignore: cast_nullable_to_non_nullable
              as Cast,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LikeNotificationData extends _LikeNotificationData {
  const _$_LikeNotificationData({required this.profile, required this.cast})
      : super._();

  factory _$_LikeNotificationData.fromJson(Map<String, dynamic> json) =>
      _$$_LikeNotificationDataFromJson(json);

  @override
  final Profile profile;
  @override
  final Cast cast;

  @override
  String toString() {
    return 'LikeNotificationData(profile: $profile, cast: $cast)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LikeNotificationData &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.cast, cast) || other.cast == cast));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, profile, cast);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LikeNotificationDataCopyWith<_$_LikeNotificationData> get copyWith =>
      __$$_LikeNotificationDataCopyWithImpl<_$_LikeNotificationData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LikeNotificationDataToJson(
      this,
    );
  }
}

abstract class _LikeNotificationData extends LikeNotificationData {
  const factory _LikeNotificationData(
      {required final Profile profile,
      required final Cast cast}) = _$_LikeNotificationData;
  const _LikeNotificationData._() : super._();

  factory _LikeNotificationData.fromJson(Map<String, dynamic> json) =
      _$_LikeNotificationData.fromJson;

  @override
  Profile get profile;
  @override
  Cast get cast;
  @override
  @JsonKey(ignore: true)
  _$$_LikeNotificationDataCopyWith<_$_LikeNotificationData> get copyWith =>
      throw _privateConstructorUsedError;
}

TagNotificationData _$TagNotificationDataFromJson(Map<String, dynamic> json) {
  return _TagNotificationData.fromJson(json);
}

/// @nodoc
mixin _$TagNotificationData {
  Cast get cast => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TagNotificationDataCopyWith<TagNotificationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagNotificationDataCopyWith<$Res> {
  factory $TagNotificationDataCopyWith(
          TagNotificationData value, $Res Function(TagNotificationData) then) =
      _$TagNotificationDataCopyWithImpl<$Res, TagNotificationData>;
  @useResult
  $Res call({Cast cast});

  $CastCopyWith<$Res> get cast;
}

/// @nodoc
class _$TagNotificationDataCopyWithImpl<$Res, $Val extends TagNotificationData>
    implements $TagNotificationDataCopyWith<$Res> {
  _$TagNotificationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cast = null,
  }) {
    return _then(_value.copyWith(
      cast: null == cast
          ? _value.cast
          : cast // ignore: cast_nullable_to_non_nullable
              as Cast,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CastCopyWith<$Res> get cast {
    return $CastCopyWith<$Res>(_value.cast, (value) {
      return _then(_value.copyWith(cast: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_TagNotificationDataCopyWith<$Res>
    implements $TagNotificationDataCopyWith<$Res> {
  factory _$$_TagNotificationDataCopyWith(_$_TagNotificationData value,
          $Res Function(_$_TagNotificationData) then) =
      __$$_TagNotificationDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Cast cast});

  @override
  $CastCopyWith<$Res> get cast;
}

/// @nodoc
class __$$_TagNotificationDataCopyWithImpl<$Res>
    extends _$TagNotificationDataCopyWithImpl<$Res, _$_TagNotificationData>
    implements _$$_TagNotificationDataCopyWith<$Res> {
  __$$_TagNotificationDataCopyWithImpl(_$_TagNotificationData _value,
      $Res Function(_$_TagNotificationData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cast = null,
  }) {
    return _then(_$_TagNotificationData(
      cast: null == cast
          ? _value.cast
          : cast // ignore: cast_nullable_to_non_nullable
              as Cast,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TagNotificationData extends _TagNotificationData {
  const _$_TagNotificationData({required this.cast}) : super._();

  factory _$_TagNotificationData.fromJson(Map<String, dynamic> json) =>
      _$$_TagNotificationDataFromJson(json);

  @override
  final Cast cast;

  @override
  String toString() {
    return 'TagNotificationData(cast: $cast)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TagNotificationData &&
            (identical(other.cast, cast) || other.cast == cast));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, cast);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TagNotificationDataCopyWith<_$_TagNotificationData> get copyWith =>
      __$$_TagNotificationDataCopyWithImpl<_$_TagNotificationData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TagNotificationDataToJson(
      this,
    );
  }
}

abstract class _TagNotificationData extends TagNotificationData {
  const factory _TagNotificationData({required final Cast cast}) =
      _$_TagNotificationData;
  const _TagNotificationData._() : super._();

  factory _TagNotificationData.fromJson(Map<String, dynamic> json) =
      _$_TagNotificationData.fromJson;

  @override
  Cast get cast;
  @override
  @JsonKey(ignore: true)
  _$$_TagNotificationDataCopyWith<_$_TagNotificationData> get copyWith =>
      throw _privateConstructorUsedError;
}

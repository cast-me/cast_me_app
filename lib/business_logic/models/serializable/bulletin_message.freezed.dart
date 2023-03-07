// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulletin_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BulletinMessage _$BulletinMessageFromJson(Map<String, dynamic> json) {
  return _BulletinMessage.fromJson(json);
}

/// @nodoc
mixin _$BulletinMessage {
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BulletinMessageCopyWith<BulletinMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BulletinMessageCopyWith<$Res> {
  factory $BulletinMessageCopyWith(
          BulletinMessage value, $Res Function(BulletinMessage) then) =
      _$BulletinMessageCopyWithImpl<$Res, BulletinMessage>;
  @useResult
  $Res call({String title, String message});
}

/// @nodoc
class _$BulletinMessageCopyWithImpl<$Res, $Val extends BulletinMessage>
    implements $BulletinMessageCopyWith<$Res> {
  _$BulletinMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BulletinMessageCopyWith<$Res>
    implements $BulletinMessageCopyWith<$Res> {
  factory _$$_BulletinMessageCopyWith(
          _$_BulletinMessage value, $Res Function(_$_BulletinMessage) then) =
      __$$_BulletinMessageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String message});
}

/// @nodoc
class __$$_BulletinMessageCopyWithImpl<$Res>
    extends _$BulletinMessageCopyWithImpl<$Res, _$_BulletinMessage>
    implements _$$_BulletinMessageCopyWith<$Res> {
  __$$_BulletinMessageCopyWithImpl(
      _$_BulletinMessage _value, $Res Function(_$_BulletinMessage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? message = null,
  }) {
    return _then(_$_BulletinMessage(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BulletinMessage extends _BulletinMessage {
  const _$_BulletinMessage({required this.title, required this.message})
      : super._();

  factory _$_BulletinMessage.fromJson(Map<String, dynamic> json) =>
      _$$_BulletinMessageFromJson(json);

  @override
  final String title;
  @override
  final String message;

  @override
  String toString() {
    return 'BulletinMessage(title: $title, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BulletinMessage &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BulletinMessageCopyWith<_$_BulletinMessage> get copyWith =>
      __$$_BulletinMessageCopyWithImpl<_$_BulletinMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BulletinMessageToJson(
      this,
    );
  }
}

abstract class _BulletinMessage extends BulletinMessage {
  const factory _BulletinMessage(
      {required final String title,
      required final String message}) = _$_BulletinMessage;
  const _BulletinMessage._() : super._();

  factory _BulletinMessage.fromJson(Map<String, dynamic> json) =
      _$_BulletinMessage.fromJson;

  @override
  String get title;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$_BulletinMessageCopyWith<_$_BulletinMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

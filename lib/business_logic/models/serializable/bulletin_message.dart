// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bulletin_message.freezed.dart';

part 'bulletin_message.g.dart';

/// flutter pub run build_runner build
@freezed
class BulletinMessage with _$BulletinMessage {
  const factory BulletinMessage({
    required String title,
    required String message
  }) = _BulletinMessage;

  const BulletinMessage._();

  factory BulletinMessage.fromJson(Map<String, Object?> json) =>
      _$BulletinMessageFromJson(json);
}

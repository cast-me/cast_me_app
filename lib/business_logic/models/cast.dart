// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/models/protobufs/cast_base.pb.dart';
import 'package:cast_me_app/business_logic/models/protobufs/like_base.pb.dart';
import 'package:cast_me_app/business_logic/models/protobufs/topic_base.pb.dart';
import 'package:cast_me_app/util/color_utils.dart';
import 'package:cast_me_app/util/string_utils.dart';
import 'package:cast_me_app/util/uri_utils.dart';

typedef Cast = CastBase;
typedef Like = LikeBase;
typedef Topic = TopicBase;

extension CastUtils on CastBase {
  static Cast mock({
    required String authorDisplayName,
    required Duration duration,
    required String title,
    required Uri image,
    required Color accentColor,
  }) {
    return Cast(
      authorId: authorDisplayName.hashCode.toString(),
      authorDisplayName: authorDisplayName,
      durationMs: duration.inMilliseconds,
      title: title,
      imageUrl: image.toString(),
      accentColorBase: accentColor.serialize,
    );
  }

  Uri get imageUri => Uri.parse(imageUrl);

  Uri get audioUri => Uri.parse(
        audioUrl.emptyToNull ??
            'https://www.americanrhetoric.com/mp3clips/politicalspeeches/jfkinaugural2.mp3',
      );

  Uri? get externalUri {
    return UriUtils.tryParse(externalUrl);
  }

  String get audioPath => audioUri.pathSegments.last;

  DateTime get createdAt => DateTime.parse(createdAtString);

  Color get accentColor =>
      ColorUtils.deserialize(accentColorBase.emptyToNull ?? 'FFFFFFFF');

  Duration get duration => Duration(milliseconds: durationMs);

  bool get isEmpty => id.isEmpty;

  bool get isNotEmpty => id.isNotEmpty;

  bool get userLiked =>
      likes.any((like) => AuthManager.instance.profile.id == like.userId);
}

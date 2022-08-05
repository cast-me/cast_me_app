import 'dart:ui';

import 'package:cast_me_app/business_logic/models/protobufs/cast_base.pb.dart';
import 'package:cast_me_app/util/color_utils.dart';
import 'package:cast_me_app/util/string_utils.dart';

typedef Cast = CastBase;

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
      imageUriBase: image.toString(),
      accentColorBase: accentColor.serialize,
    );
  }

  Uri get imageUri => Uri.parse(imageUriBase);

  Uri get audioUri => Uri.parse(
        audioUriBase.emptyToNull ??
            'https://www.americanrhetoric.com/mp3clips/politicalspeeches/jfkinaugural2.mp3',
      );

  Color get accentColor => ColorUtils.deserialize(accentColorBase);

  Duration get duration => Duration(milliseconds: durationMs);
}

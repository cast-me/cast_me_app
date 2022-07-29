import 'dart:ui';

import 'package:cast_me_app/business_logic/models/protobufs/cast_base.pb.dart';
import 'package:cast_me_app/util/string_utils.dart';

typedef Cast = CastBase;

extension CastUtils on CastBase {
  static Cast mock({
    required String author,
    required Duration duration,
    required String title,
    required Uri image,
    required Color accentColor,
  }) {
    return Cast(
      author: author,
      durationMs: duration.inMilliseconds,
      title: title,
      imageUriBase: image.toString(),
      accentColorBase: accentColor.value.toRadixString(16),
    );
  }

  Uri get imageUri => Uri.parse(imageUriBase);

  Uri get audioUri => Uri.parse(
        audioUriBase.zeroToNull ??
            'https://www.americanrhetoric.com/mp3clips/politicalspeeches/jfkinaugural2.mp3',
      );

  Color get accentColor => Color(int.parse(accentColorBase, radix: 16));

  Duration get duration => Duration(milliseconds: durationMs);
}

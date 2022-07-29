import 'dart:ui';

import 'package:cast_me_app/business_logic/models/protobufs/cast_base.pb.dart';

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
      accentColorBase: ColorBase(
        a: accentColor.alpha,
        r: accentColor.red,
        g: accentColor.green,
        b: accentColor.blue,
      ),
    );
  }

  Uri get imageUri => Uri.parse(imageUriBase);

  Uri get audioUri => Uri.parse(
        'https://www.americanrhetoric.com/mp3clips/politicalspeeches/jfkinaugural2.mp3',
      );

  Color get accentColor => Color.fromARGB(
        accentColorBase.a,
        accentColorBase.r,
        accentColorBase.g,
        accentColorBase.b,
      );

  Duration get duration => Duration(milliseconds: durationMs);
}

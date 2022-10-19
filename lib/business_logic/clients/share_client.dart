import 'package:cast_me_app/business_logic/models/cast.dart';

import 'package:share_plus/share_plus.dart';

class ShareClient {
  ShareClient._();

  static final ShareClient instance = ShareClient._();

  static const String _castMeDomain = 'https://www.getcastme.com';

  Future<void> share(Cast cast) async {
    await Share.share(
      'Check out this hot take on CastMe:\n'
      '$_castMeDomain/casts/${cast.id}',
      subject: cast.title,
    );
  }
}

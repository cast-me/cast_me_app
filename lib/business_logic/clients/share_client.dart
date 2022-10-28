// Package imports:
import 'package:share_plus/share_plus.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/cast.dart';

class ShareClient {
  ShareClient._();

  static final ShareClient instance = ShareClient._();

  static const String _castMeDomain = 'https://www.getcastme.com';

  Future<void> share(Cast cast) async {
    await Share.share(
      // TODO: make these constants and store them somewhere.
      '$_castMeDomain/users/${cast.authorUsername}'
      '/casts/${cast.id.substring(0, 8)}',
      subject: cast.title,
    );
  }
}

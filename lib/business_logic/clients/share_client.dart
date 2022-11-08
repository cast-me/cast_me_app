// Package imports:
import 'package:share_plus/share_plus.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/cast.dart';

import 'package:social_share/social_share.dart';

class ShareClient {
  ShareClient._();

  static final ShareClient instance = ShareClient._();

  static const String _castMeDomain = 'https://www.getcastme.com';

  Future<void> share(Cast cast) async {
    await Share.share(
      // TODO: make these constants and store them somewhere.
      castShareUrl(cast),
      subject: cast.title,
    );
  }

  Future<void> shareToTwitter(Cast cast) async {
    await SocialShare.shareTwitter(
      // Space at end because `SocialShare` doesn't add a space between the
      // hashtags and the content.
      'Check out my hot take on CastMe! ',
      hashtags: ['CastMe', ...cast.topicNames],
      url: castShareUrl(cast),
    );
  }

  String castShareUrl(Cast cast) {
    return '$_castMeDomain/users/${cast.authorUsername}'
        '/casts/${cast.id.substring(0, 8)}';
  }
}

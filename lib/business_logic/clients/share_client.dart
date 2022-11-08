// Package imports:
import 'package:share_plus/share_plus.dart';
import 'package:social_share/social_share.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/cast.dart';

class ShareClient {
  ShareClient._();

  static final ShareClient instance = ShareClient._();

  static const String _castMeDomain = 'https://www.getcastme.com';

  static const String _sharePrefix = 'Check out my hot take on CastMe! ';

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
      _sharePrefix,
      hashtags: ['CastMe', ...cast.topicNames],
      url: castShareUrl(cast),
    );
  }

  Future<void> shareToWhatsapp(Cast cast) async {
    await SocialShare.shareWhatsapp(
      'Check out my hot take on CastMe!\n${castShareUrl(cast)}',
    );
  }

  String castShareUrl(Cast cast) {
    return '$_castMeDomain/users/${cast.authorUsername}'
        '/casts/${cast.id.substring(0, 8)}';
  }
}

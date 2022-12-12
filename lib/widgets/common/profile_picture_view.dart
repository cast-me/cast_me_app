// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';

class ProfilePictureView extends StatelessWidget {
  const ProfilePictureView({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return ProfilePictureBaseView(
      imageProvider: CachedNetworkImageProvider(profile.profilePictureUrl),
    );
  }
}

class ProfilePictureBaseView extends StatelessWidget {
  const ProfilePictureBaseView({
    super.key,
    required this.imageProvider,
  });

  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: imageProvider,
        ),
      ),
    );
  }
}

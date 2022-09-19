import 'package:cast_me_app/business_logic/models/protobufs/cast_me_profile_base.pbserver.dart';
import 'package:flutter/material.dart';

class ProfilePictureView extends StatelessWidget {
  const ProfilePictureView({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final CastMeProfileBase profile;

  @override
  Widget build(BuildContext context) {
    return ProfilePictureBaseView(
      imageProvider: NetworkImage(profile.profilePictureUrl),
    );
  }
}

class ProfilePictureBaseView extends StatelessWidget {
  const ProfilePictureBaseView({
    Key? key,
    required this.imageProvider,
  }) : super(key: key);

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

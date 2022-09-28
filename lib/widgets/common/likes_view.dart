import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

class LikesView extends StatefulWidget {
  const LikesView({Key? key}) : super(key: key);

  @override
  State<LikesView> createState() => _LikesViewState();
}

// TODO(caseycrogers): this is a sloppy mess with local caching vs server
//   values, this should really be made not shit.
class _LikesViewState extends State<LikesView> {
  late final Cast cast = CastProvider.of(context);
  late bool userLiked =
      cast.likes.any((l) => l.userId == AuthManager.instance.profile.id);

  bool get locallyOverridden =>
      userLiked !=
      cast.likes.any((l) => l.userId == AuthManager.instance.profile.id);

  late int likeCount = _getNumberOfLikes();

  @override
  Widget build(BuildContext context) {
    return _LikeView(
      icon: const Icon(
        Icons.thumb_up,
        size: 12,
      ),
      label: Text(
        likeCount.toString(),
        style: const TextStyle(fontSize: 12),
      ),
      color: userLiked ? Colors.grey : null,
      onTap: () async {
        await CastDatabase.instance.setLiked(cast: cast, liked: !userLiked);
        setState(() {
          userLiked = !userLiked;
          likeCount = _getNumberOfLikes();
        });
      },
    );
  }

  // Broken out to add hacky compensation for local changes.
  int _getNumberOfLikes() {
    final int serverCount = cast.likes.length;
    if (userLiked && locallyOverridden) {
      // The local override was a like.
      return serverCount + 1;
    }
    if (!userLiked && locallyOverridden) {
      // The local override was an unlike.
      return serverCount - 1;
    }
    return serverCount;
  }
}

class _LikeView extends StatelessWidget {
  const _LikeView({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  final Widget icon;
  final Widget label;
  final Color? color;
  final AsyncCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 2),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            color: color ?? Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 2),
            label,
          ],
        ),
      ),
    );
  }
}

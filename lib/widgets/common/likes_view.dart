import 'package:async_list_view/async_list_view.dart';
import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/profile_page/profile_view.dart';
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

  static const double size = 16;

  @override
  Widget build(BuildContext context) {
    return _LikeView(
      icon: const Icon(
        Icons.thumb_up,
        size: size,
      ),
      label: Text(
        likeCount.toString(),
        style: const TextStyle(fontSize: size),
      ),
      color: Theme.of(context).colorScheme.surface,
      border: userLiked,
      onTap: () async {
        await CastDatabase.instance.setLiked(cast: cast, liked: !userLiked);
        setState(
          () {
            userLiked = !userLiked;
            likeCount = _getNumberOfLikes();
          },
        );
      },
      onLongTap: () {
        if (likeCount == 0) {
          return;
        }
        final List<String> likeIds = cast.likes.map((l) => l.userId).toList();
        if (!userLiked) {
          likeIds.remove(AuthManager.instance.profile.id);
        } else if (locallyOverridden) {
          // User has liked the cast since it was locally cached, manually add
          // them to the list.
          likeIds.add(AuthManager.instance.profile.id);
        }
        // TODO(caseycrogers): actually position this in a sane spot.
        showDialog<void>(
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.topCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: AdaptiveMaterial(
                    adaptiveColor: AdaptiveColor.surface,
                    child: AsyncListView<Profile>(
                      padding: const EdgeInsets.all(12),
                      shrinkWrap: true,
                      stream: AuthManager.instance.getProfiles(ids: likeIds),
                      loadingWidget: Container(
                        height: 24,
                        width: 24,
                        alignment: Alignment.center,
                        child: const AspectRatio(
                          aspectRatio: 1,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      itemBuilder: (context, snapshot, index) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        final Profile profile = snapshot.data![index];
                        return Padding(
                          padding: EdgeInsets.only(top: index != 0 ? 4 : 0),
                          child: ProfilePreview(
                            profile: profile,
                            onTap: () {
                              CastMeBloc.instance.onProfileSelected(profile);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
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
    required this.border,
    required this.onLongTap,
  }) : super(key: key);

  final Widget icon;
  final Widget label;
  final Color color;
  final bool border;
  final AsyncCallback? onTap;
  final VoidCallback? onLongTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongTap,
      child: Container(
        margin: const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(
            color: border ? Colors.white : Colors.transparent,
            width: 1,
          ),
          color: color,
          borderRadius: BorderRadius.circular(20),
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

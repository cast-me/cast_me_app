// Flutter imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:async_list_view/async_list_view.dart';

// Project imports:
import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/widgets/profile_page/profile_view.dart';

class LikesView extends StatefulWidget {
  const LikesView({Key? key}) : super(key: key);

  @override
  State<LikesView> createState() => _LikesViewState();
}

class _LikesViewState extends State<LikesView> {
  static const double size = 20;

  @override
  Widget build(BuildContext context) {
    final CastProviderData currentCast = CastProvider.of(context);
    return ValueListenableBuilder<Cast>(
        valueListenable: currentCast,
        builder: (context, cast, _) {
          final List<Like> likes = cast.likes ?? [];
          final bool userLiked = likes
              .any((like) => like.userId == AuthManager.instance.profile.id);
          final int likeCount = likes.length;
          return _LikeView(
            icon: const Icon(
              Icons.thumb_up,
              size: size,
            ),
            label: Text(
              likes.length.toString(),
              style: const TextStyle(fontSize: size),
            ),
            color: Theme.of(context).colorScheme.surface,
            border: userLiked,
            onTap: () async {
              await currentCast.setLiked(!userLiked);
            },
            onLongTap: () {
              if (likeCount == 0) {
                return;
              }
              final List<String> likeIds = likes.map((l) => l.userId).toList();
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
                        child: AdaptiveMaterial.surface(
                          child: AsyncListView<Profile>(
                            padding: const EdgeInsets.all(12),
                            shrinkWrap: true,
                            stream:
                                AuthManager.instance.getProfiles(ids: likeIds),
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
                                padding:
                                    EdgeInsets.only(top: index != 0 ? 4 : 0),
                                child: ProfilePreview(
                                  profile: profile,
                                  onTap: () {
                                    CastMeBloc.instance
                                        .onProfileSelected(profile);
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
        });
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

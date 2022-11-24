// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';

class ReplyCastSelector extends StatelessWidget {
  const ReplyCastSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '1. Reply to',
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<Cast?>(
          valueListenable: PostBloc.instance.replyCast,
          builder: (context, cast, _) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) {
                          return const SelectCastModal();
                        },
                      );
                    },
                    child: Container(
                      height: cast == null ? 66 : null,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: AdaptiveMaterial.background(
                          child: Center(
                            child: cast == null
                                ? const Text(
                                    'Select a cast (optional)',
                                  )
                                : CastViewTheme(
                                    isInteractive: false,
                                    taggedUsersAreTappable: false,
                                    indentReplies: false,
                                    showMenu: false,
                                    showLikes: false,
                                    indicateNew: false,
                                    showLink: false,
                                    titleMaxLines: 1,
                                    child: CastPreview(cast: cast),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (cast != null)
                  IconButton(
                    onPressed: () {
                      PostBloc.instance.replyCast.value = null;
                    },
                    icon: const Icon(Icons.clear),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class SelectCastModal extends StatefulWidget {
  const SelectCastModal({
    Key? key,
    this.adaptiveColor,
  }) : super(key: key);

  final AdaptiveMaterialType? adaptiveColor;

  @override
  State<SelectCastModal> createState() => _SelectCastModalState();
}

class _SelectCastModalState extends State<SelectCastModal> {
  final CastMeSearchListController<Cast> searchController =
      CastMeSearchListController<Cast>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AdaptiveMaterial(
          material: widget.adaptiveColor ?? AdaptiveMaterialType.surface,
          child: Column(
            children: [
              _CastSearchBar(searchController: searchController),
              Expanded(
                child: CastViewTheme(
                  taggedUsersAreTappable: false,
                  showMenu: false,
                  showLikes: false,
                  indicateNew: false,
                  showLink: false,
                  onTap: (cast) {
                    Navigator.of(context).pop();
                    PostBloc.instance.replyCast.value = cast;
                  },
                  child: CastListView(
                    controller: searchController,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CastSearchBar extends StatelessWidget {
  const _CastSearchBar({
    Key? key,
    required this.searchController,
  }) : super(key: key);

  final CastMeSearchListController<Cast> searchController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: searchController.searchTextController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}

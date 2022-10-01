import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:flutter/material.dart';

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
        const AdaptiveText('Is a reply to:'),
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
                      height: 66,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: AdaptiveMaterial(
                          adaptiveColor: AdaptiveColor.background,
                          child: Center(
                            child: cast == null
                                ? const AdaptiveText(
                                    'Select a cast (optional)',
                                  )
                                : CastViewTheme(
                                    isInteractive: false,
                                    taggedUsersAreTappable: false,
                                    indentReplies: false,
                                    showMenu: false,
                                    showLikes: false,
                                    dimIfListened: false,
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
  }) : super(key: key);

  @override
  State<SelectCastModal> createState() => _SelectCastModalState();
}

class _SelectCastModalState extends State<SelectCastModal> {
  final SearchCastListController searchController = SearchCastListController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AdaptiveMaterial(
          adaptiveColor: AdaptiveColor.surface,
          child: Column(
            children: [
              _CastSearchBar(searchController: searchController),
              Expanded(
                child: CastViewTheme(
                  taggedUsersAreTappable: false,
                  showMenu: false,
                  showLikes: false,
                  dimIfListened: false,
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

  final SearchCastListController searchController;

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

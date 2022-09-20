import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';
import 'package:flutter/material.dart';

class ReplyCastSelector extends StatelessWidget {
  const ReplyCastSelector({
    Key? key,
    required this.replyCast,
  }) : super(key: key);

  final ValueNotifier<Cast?> replyCast;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AdaptiveText('Is a reply to:'),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (context) {
                return _SelectCastModal(replyCast: replyCast);
              },
            );
          },
          child: Container(
            height: 66,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const AdaptiveMaterial(
                adaptiveColor: AdaptiveColor.background,
                child: Center(
                  child: AdaptiveText(
                    'Select a cast (optional)',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectCastModal extends StatefulWidget {
  const _SelectCastModal({
    Key? key,
    required this.replyCast,
  }) : super(key: key);

  final ValueNotifier<Cast?> replyCast;

  @override
  State<_SelectCastModal> createState() => _SelectCastModalState();
}

class _SelectCastModalState extends State<_SelectCastModal> {
  final SearchCastListController searchController =
      SearchCastListController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: AdaptiveMaterial(
        adaptiveColor: AdaptiveColor.background,
        child: Column(
          children: [
            _CastSearchBar(searchController: searchController),
            Expanded(
              child: CastListView(
                controller: searchController,
                fullyInteractive: false,
              ),
            ),
          ],
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
          filled: true,
          fillColor: Colors.black,
        ),
      ),
    );
  }
}

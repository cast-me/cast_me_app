// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';

class CastListView extends StatelessWidget {
  const CastListView({
    Key? key,
    this.filterProfile,
    this.filterOutProfile,
    this.filterTopics,
    this.padding,
    this.controller,
  }) : super(key: key);

  /// If non-null, fetch only casts authored by the specified user.
  final Profile? filterProfile;

  /// If non-null, exclude casts by the specified user.
  final Profile? filterOutProfile;

  /// If non-null, restrict casts to the given topic.
  final List<Topic>? filterTopics;

  final EdgeInsets? padding;

  final CastMeListController<Cast>? controller;

  @override
  Widget build(BuildContext context) {
    return CastMeListView<Cast>(
      controller: controller,
      getStream: () => CastDatabase.instance
          .getCasts(
        filterProfile: filterProfile,
        filterOutProfile: filterOutProfile,
        filterTopics: filterTopics,
        searchTerm: controller?.searchTextController?.text,
      )
          .handleError(
        (Object error, StackTrace stackTrace) {
          if (kDebugMode) {
            print(error);
            print(stackTrace);
          }
        },
      ),
      builder: (context, casts, index) {
        return CastPreview(
          padding: const EdgeInsets.only(
            top: 4,
            bottom: 2,
            left: 12,
            right: 12,
          ),
          cast: casts[index],
        );
      },
    );
  }
}

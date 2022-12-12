// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/widgets/common/cast_me_list_view.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';

class CastListView extends StatelessWidget {
  const CastListView({
    super.key,
    this.padding,
    this.controller,
  });

  final EdgeInsets? padding;

  final CastMeListController<Cast>? controller;

  @override
  Widget build(BuildContext context) {
    return CastMeListView<Cast>(
      controller: controller,
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

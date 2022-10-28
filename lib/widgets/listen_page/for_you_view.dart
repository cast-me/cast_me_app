// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/casts_list_view.dart';

class ForYouView extends StatelessWidget {
  const ForYouView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CastViewTheme(
      child: CastListView(
        padding: EdgeInsets.all(8),
      ),
    );
  }
}

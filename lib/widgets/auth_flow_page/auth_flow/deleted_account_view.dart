// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/widgets/common/cast_me_page.dart';

class DeletedAccountView extends StatelessWidget {
  const DeletedAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CastMePage(
      headerText: 'Deleted account',
      child: Column(
        children: const [
          Text(
            'Your account has been deleted.\n'
            'You may have deleted it yourself or you may have been banned from '
            'CastMe.\n\n'
            'Reach out to CastMe for support.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

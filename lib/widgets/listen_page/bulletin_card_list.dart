// Flutter imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:cast_me_app/business_logic/models/serializable/bulletin_message.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/util/async_action_wrapper.dart';

class BulletinCardList extends StatelessWidget {
  const BulletinCardList({
    super.key,
    this.padding,
  });

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Future<BulletinMessage>>(
      valueListenable: ValueNotifier(
        Future.value(
          const BulletinMessage(
            title: 'Join CastMe Social Hour!',
            message: 'Jump on CastMe this Thursday to join in on hosted '
                'conversations or start your own!',
          ),
        ),
      ),
      builder: (context, bulletinMessage, child) {
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AdaptiveMaterial.surface(
              child: FutureBuilder<BulletinMessage>(
                future: bulletinMessage,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return ErrorText(error: snap.error!);
                  }
                  if (!snap.hasData) {
                    return Container();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BulletinView(bulletinMessage: snap.data!),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class BulletinView extends StatelessWidget {
  const BulletinView({
    super.key,
    required this.bulletinMessage,
  });

  final BulletinMessage bulletinMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8).subtract(const EdgeInsets.only(
        bottom: 8,
      )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.feed),
              const SizedBox(width: 4),
              Text(bulletinMessage.title),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            bulletinMessage.message,
            style: TextStyle(
              color: AdaptiveMaterial.secondaryOnColorOf(context),
            ),
          ),
        ],
      ),
    );
  }
}

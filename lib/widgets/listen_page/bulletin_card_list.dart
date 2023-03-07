// Flutter imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:cast_me_app/business_logic/for_you_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/bulletin_message.dart';
import 'package:flutter/material.dart';

// Project imports:

class BulletinCardList extends StatelessWidget {
  const BulletinCardList({
    super.key,
    this.padding,
  });

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BulletinMessage?>(
      valueListenable: ForYouBloc.instance.bulletinMessage,
      builder: (context, bulletinMessage, child) {
        if (bulletinMessage == null) {
          // Should only be applicable while the message is loading in.
          return Container();
        }
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AdaptiveMaterial.surface(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BulletinView(bulletinMessage: bulletinMessage),
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

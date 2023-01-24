// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';

class PlayNewCard extends StatelessWidget {
  const PlayNewCard({super.key, required this.seedCast});

  final Cast seedCast;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: () {
          ListenBloc.instance.onPlayAll(
            seedCast: seedCast,
          );
        },
        child: AdaptiveMaterial.surface(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Icon(Icons.play_circle, size: 40, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  'Play new casts',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

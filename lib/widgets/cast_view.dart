import 'package:cast_me_app/models/cast.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' show join;

class CastPreview extends StatelessWidget {
  const CastPreview({
    required this.cast,
    Key? key,
  }) : super(key: key);

  final Cast cast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Image.asset(
                join('assets', 'images', cast.image ?? 'thisisfine.png'),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cast.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  DefaultTextStyle(
                    style: TextStyle(color: Colors.grey.shade400),
                    child: Row(
                      children: [
                        Text(cast.author),
                        const Text(' - '),
                        Text(cast.duration.toFormattedString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension FormattedDuration on Duration {
  String toFormattedString() {
    return '${inMinutes.toString()}:'
        '${(inSeconds ~/ 60 * inMinutes).toString().padLeft(2, '0')}';
  }
}

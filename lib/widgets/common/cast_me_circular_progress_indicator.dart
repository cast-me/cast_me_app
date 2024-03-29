// Flutter imports:
import 'package:flutter/material.dart';

class CastMeCircularProgressIndicator extends StatelessWidget {
  const CastMeCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}

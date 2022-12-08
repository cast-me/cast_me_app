import 'package:flutter/material.dart';

class CastMeCircularProgressIndicator extends StatelessWidget {
  const CastMeCircularProgressIndicator({Key? key}) : super(key: key);

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

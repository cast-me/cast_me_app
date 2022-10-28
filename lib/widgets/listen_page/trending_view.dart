// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/trend.dart';
import 'package:cast_me_app/mock_data.dart';

class TrendingView extends StatelessWidget {
  TrendingView({Key? key}) : super(key: key);

  final List<Trend> trends = [
    jan6Committee,
    bipartisanGunDeal,
    castMeBuyout,
    ukraine,
  ];

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Coming Soon!'));
  }
}

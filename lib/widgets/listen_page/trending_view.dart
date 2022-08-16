import 'package:cast_me_app/business_logic/models/trend.dart';
import 'package:cast_me_app/mock_data.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/util/collection_utils.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:flutter/material.dart';

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
    return GestureDetector(
      child: const Center(child: Text('Coming Soon!')),
      onTap: () {
        throw Exception('asdfasdf');
      },
    );
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        ...trends.map((trend) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8, top: 8),
                    child: AdaptiveText(
                      trend.trendText,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ],
              ),
              Text(
                '${trend.size} Casts',
                style: TextStyle(
                  color: Colors.white.withAlpha(150),
                ),
              ),
              // ignore: unnecessary_cast
              ...(trend.casts.map((cast) {
                return CastPreview(cast: cast);
              }) as Iterable<Widget>)
                  .separated(const SizedBox(height: 8)),
            ],
          );
        }),
      ],
    );
  }
}

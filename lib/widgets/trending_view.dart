import 'package:cast_me_app/mock_data.dart';
import 'package:cast_me_app/models/cast.dart';
import 'package:cast_me_app/models/trend.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/util/collection_utils.dart';
import 'package:cast_me_app/widgets/cast_view.dart';
import 'package:flutter/material.dart';

class TrendingView extends StatelessWidget {
  TrendingView({Key? key}) : super(key: key);

  final List<Trend> trends = [
    jan6Committee,
    bipartisanGunDeal,
    const Trend(
      trendText: 'CastMeSpotifyBuyout',
      size: '900k',
      casts: [
        Cast(
          author: 'Elon Musk',
          title: 'Why I\'m submitting a counteroffer for CastMe',
          duration: Duration(seconds: 126),
          image: 'musk.png',
        ),
        Cast(
          author: 'Luigi Panzeri',
          title: 'The 2.5b buyout is definitely too low given CastMe\'s '
              'immense growth potential',
          duration: Duration(seconds: 205),
          image: 'luigi.jpg',
        ),
      ],
    ),
    const Trend(
      trendText: 'Ukraine',
      size: '8.2m',
      casts: [
        Cast(
          author: 'Elon Musk',
          title: 'Why I\'m submitting a counteroffer for CastMe',
          duration: Duration(seconds: 186),
        ),
        Cast(
          author: 'Luigi Panzeri',
          title: 'The 2.5b buyout is definitely too low given CastMe\'s '
              'immense growth potential',
          duration: Duration(seconds: 210),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

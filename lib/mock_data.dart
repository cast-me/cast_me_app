import 'package:cast_me_app/models/cast.dart';
import 'package:cast_me_app/models/trend.dart';

/// Mock casts.
const Cast ezraLoneliness = Cast(
  author: 'Ezra Klein',
  duration: Duration(seconds: 295),
  title: 'Combating the loneliness epidemic',
  image: 'ezra.jpg',
);

const Cast codyJan6 = Cast(
  author: 'Cody Johnston',
  title: 'The crime president is put on trial. For crimes.',
  duration: Duration(seconds: 356),
  image: 'smn.png',
);

const Cast wittesJan6 = Cast(
  author: 'Benjamin Wittes',
  title: 'Donald Trump, Jan 6th and Section 3 of the 14th Amendment',
  duration: Duration(seconds: 256),
  image: 'wittes.png',
);

const Cast ezraGunDeal = Cast(
  author: 'Ezra Klein',
  title: 'Democrats are finally breaking the stalemate on gun control',
  duration: Duration(seconds: 175),
  image: 'ezra.jpg',
);

const Cast nateGunDeal = Cast(
  author: 'Nate Silver',
  title: 'Americans say they want universal background checks, '
      'but the polling is complicated',
  duration: Duration(seconds: 156),
  image: 'nate_silver.png',
);

/// Mock trends.
const Trend jan6Committee = Trend(
  trendText: 'Jan6Committee',
  size: '1.5m',
  casts: [codyJan6, wittesJan6],
);

const Trend bipartisanGunDeal = Trend(
  trendText: 'BipartisanGunDeal',
  size: '2.9m',
  casts: [nateGunDeal, ezraGunDeal],
);

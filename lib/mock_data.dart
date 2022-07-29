import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/models/trend.dart';

import 'package:flutter/material.dart';

/// Mock casts.
Cast ezraLoneliness = CastUtils.mock(
  author: 'Ezra Klein',
  duration: const Duration(seconds: 295),
  title: 'Combating the loneliness epidemic',
  image:
      Uri.parse('gs://cast-me-app.appspot.com/user_profile_pictures/ezra.jpg'),
  accentColor: const Color.fromRGBO(230, 163, 84, 1),
);

Cast codyJan6 = CastUtils.mock(
  author: 'Cody Johnston',
  title: 'The crime president is put on trial. For crimes.',
  duration: const Duration(seconds: 356),
  image:
      Uri.parse('gs://cast-me-app.appspot.com/user_profile_pictures/smn.png'),
  accentColor: const Color.fromRGBO(124, 179, 203, 1),
);

Cast wittesJan6 = CastUtils.mock(
  author: 'Benjamin Wittes',
  title: 'Donald Trump, Jan 6th and Section 3 of the 14th Amendment',
  duration: const Duration(seconds: 256),
  image: Uri.parse('gs://cast-me-app.appspot.com/user_profile_pictures/wittes.png'),
  accentColor: const Color.fromRGBO(127, 122, 142, 1),
);

Cast ezraGunDeal = CastUtils.mock(
  author: 'Ezra Klein',
  title: 'Democrats are finally breaking the stalemate on gun control',
  duration: const Duration(seconds: 175),
  image: Uri.parse('gs://cast-me-app.appspot.com/user_profile_pictures/ezra.jpg'),
  accentColor: const Color.fromRGBO(230, 163, 84, 1),
);

Cast nateGunDeal = CastUtils.mock(
  author: 'Nate Silver',
  title: 'Americans say they want universal background checks, '
      'but the polling is complicated',
  duration: const Duration(seconds: 126),
  image: Uri.parse('gs://cast-me-app.appspot.com/user_profile_pictures/ezra.jpg'),
  accentColor: const Color.fromRGBO(186, 162, 158, 1),
);

Cast muskCastMe = CastUtils.mock(
  author: 'Elon Musk',
  title: 'Why I\'m submitting a counteroffer for CastMe',
  duration: const Duration(seconds: 126),
  image: Uri.parse('gs://cast-me-app.appspot.com/user_profile_pictures/musk.png'),
  accentColor: const Color.fromRGBO(178, 61, 53, 1),
);

Cast panzeriCastMe = CastUtils.mock(
  author: 'Luigi Panzeri',
  title: 'The 2.5b buyout is definitely too low given CastMe\'s '
      'immense growth potential',
  duration: const Duration(seconds: 205),
  image: Uri.parse('gs://cast-me-app.appspot.com/user_profile_pictures/luigi.jpg'),
  accentColor: const Color.fromRGBO(152, 128, 103, 1),
);

Cast ukraineAdam = CastUtils.mock(
  author: 'adamsomething',
  title: 'Russian propoganda billboards in occupied Luhansk are a glimpse into '
      'the Russian alternate universe',
  duration: const Duration(seconds: 312),
  image: Uri.parse('gs://cast-me-app.appspot.com/user_profile_pictures/ezra.jpg'),
  accentColor: const Color.fromRGBO(152, 128, 103, 1),
);

/// Mock trends.
Trend jan6Committee = Trend(
  trendText: 'Jan6Committee',
  size: '1.5m',
  casts: [codyJan6, wittesJan6],
);

Trend bipartisanGunDeal = Trend(
  trendText: 'BipartisanGunDeal',
  size: '2.9m',
  casts: [nateGunDeal, ezraGunDeal],
);

Trend castMeBuyout = Trend(
  trendText: 'CastMeSpotifyBuyout',
  size: '900k',
  casts: [muskCastMe, panzeriCastMe],
);

Trend ukraine = Trend(
  trendText: 'Ukraine',
  size: '1.3m',
  casts: [ukraineAdam],
);

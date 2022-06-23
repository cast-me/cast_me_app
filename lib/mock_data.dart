import 'package:cast_me_app/models/cast.dart';
import 'package:cast_me_app/models/trend.dart';
import 'package:flutter/material.dart';

/// Mock casts.
const Cast ezraLoneliness = Cast(
  author: 'Ezra Klein',
  duration: Duration(seconds: 295),
  title: 'Combating the loneliness epidemic',
  baseImage: 'ezra.jpg',
  accentColor: Color.fromRGBO(230, 163, 84, 1),
);

const Cast codyJan6 = Cast(
  author: 'Cody Johnston',
  title: 'The crime president is put on trial. For crimes.',
  duration: Duration(seconds: 356),
  baseImage: 'smn.png',
  accentColor: Color.fromRGBO(124, 179, 203, 1),
);

const Cast wittesJan6 = Cast(
  author: 'Benjamin Wittes',
  title: 'Donald Trump, Jan 6th and Section 3 of the 14th Amendment',
  duration: Duration(seconds: 256),
  baseImage: 'wittes.png',
  accentColor: Color.fromRGBO(127, 122, 142, 1),
);

const Cast ezraGunDeal = Cast(
  author: 'Ezra Klein',
  title: 'Democrats are finally breaking the stalemate on gun control',
  duration: Duration(seconds: 175),
  baseImage: 'ezra.jpg',
  accentColor: Color.fromRGBO(230, 163, 84, 1),
);

const Cast nateGunDeal = Cast(
  author: 'Nate Silver',
  title: 'Americans say they want universal background checks, '
      'but the polling is complicated',
  duration: Duration(seconds: 126),
  baseImage: 'nate_silver.png',
  accentColor: Color.fromRGBO(186, 162, 158, 1),
);

const Cast muskCastMe = Cast(
  author: 'Elon Musk',
  title: 'Why I\'m submitting a counteroffer for CastMe',
  duration: Duration(seconds: 126),
  baseImage: 'musk.png',
  accentColor: Color.fromRGBO(178, 61, 53, 1),
);

const Cast panzeriCastMe = Cast(
  author: 'Luigi Panzeri',
  title: 'The 2.5b buyout is definitely too low given CastMe\'s '
      'immense growth potential',
  duration: Duration(seconds: 205),
  baseImage: 'luigi.jpg',
  accentColor: Color.fromRGBO(152, 128, 103, 1),
);

const Cast ukraineAdam = Cast(
  author: 'adamsomething',
  title: 'Russian propoganda billboards in occupied Luhansk are a glimpse into '
      'the Russian alternate universe',
  duration: Duration(seconds: 312),
  baseImage: 'adamsomething.jpg',
  accentColor: Color.fromRGBO(152, 128, 103, 1),
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

const Trend castMeBuyout = Trend(
  trendText: 'CastMeSpotifyBuyout',
  size: '900k',
  casts: [muskCastMe, panzeriCastMe],
);

const Trend ukraine = Trend(
  trendText: 'Ukraine',
  size: '1.3m',
  casts: [ukraineAdam],
);

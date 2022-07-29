import 'package:cast_me_app/business_logic/models/cast.dart';

class Trend {
  const Trend({
    required this.trendText,
    required this.size,
    required this.casts,
  });

  final String trendText;
  final String size;
  final List<Cast> casts;
}

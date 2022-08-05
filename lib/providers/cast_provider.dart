import 'package:cast_me_app/business_logic/models/cast.dart';

import 'package:flutter/widgets.dart';

class CastProvider extends InheritedWidget {
  const CastProvider({Key? key, required Widget child, required this.cast})
      : super(key: key, child: child);

  final Cast cast;

  static Cast of(BuildContext context) {
    final CastProvider? result =
        context.dependOnInheritedWidgetOfExactType<CastProvider>();
    assert(result != null, 'No CastProvider found in context');
    return result!.cast;
  }

  @override
  bool updateShouldNotify(CastProvider oldWidget) {
    return oldWidget.cast != cast;
  }
}

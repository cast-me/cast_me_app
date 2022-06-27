import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ValueListenablePageController extends PageController
    implements ValueListenable<double> {
  @override
  double get value => page!;
}

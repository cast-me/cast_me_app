import 'package:flutter/cupertino.dart';

class RecordBloc {
  RecordBloc._();

  static final RecordBloc instance = RecordBloc._();

  final ValueNotifier<String?> recordingPath = ValueNotifier(null);
}
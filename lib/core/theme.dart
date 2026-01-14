import 'dart:ui';

import 'package:ctrl/ctrl.dart';

class AppThemeCtrl with Ctrl {
  late final _brightness = mutable<Brightness>(Brightness.dark);
  late final Observable<Brightness> brightness = _brightness;

  void toggleTheme() {
    _brightness.value = _brightness.value == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
  }
}

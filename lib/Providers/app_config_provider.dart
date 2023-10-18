import 'package:flutter/material.dart';

class AppConfigProvider extends ChangeNotifier {
  // data
  ThemeMode appTheme = ThemeMode.light; //default theme
  String appLanguage = 'en';

  void changeTheme(ThemeMode newMode) {
    if (appTheme == newMode) {
      return;
    }
    appTheme = newMode;

    /// equal wa7da bss
    notifyListeners();
  }

  void newLang(String newLang) {
    if (appLanguage == newLang) {
      return;
    }
    appLanguage = newLang;
    notifyListeners();
  }

  bool isDark() {
    return appTheme == ThemeMode.dark;
  }
}

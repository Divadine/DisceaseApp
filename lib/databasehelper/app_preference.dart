import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // fontChange
  static const String _appFont = 'app_font';

  static Future<bool> setFontChange(String isFontChanged) {
    return _prefs.setString(_appFont, isFontChanged);
  }

  static String? getFontChange() {
    return _prefs.getString(_appFont);
  }

  static Future<bool> removeFontChange() async {
    return _prefs.remove(_appFont);
  }

  //theme
  static const String _themeChange = 'theme_change';

  static Future<bool> setTheme(bool theme) {
    return _prefs.setBool(_themeChange, theme);
  }

  static bool getTheme() {
    return _prefs.getBool(_themeChange) ?? false;
  }
}

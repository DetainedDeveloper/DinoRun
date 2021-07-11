import 'package:shared_preferences/shared_preferences.dart';

class GamePreferences {
  static const String _bg = 'bg';
  static const String _sfx = 'sfx';
  
  static Future<SharedPreferences> get _preferences async => await SharedPreferences.getInstance();
  
  static Future<void> setBG(bool value) async {
    SharedPreferences preferences = await _preferences;
    preferences.setBool(_bg, value);
  }
  
  static Future<bool> getBG() async {
    SharedPreferences preferences = await _preferences;
    final value = preferences.getBool(_bg);
    return value != null ? value : true;
  }
  
  static Future<void> setSFX(bool value) async {
    SharedPreferences preferences = await _preferences;
    preferences.setBool(_sfx, value);
  }
  
  static Future<bool> getSFX() async {
    SharedPreferences preferences = await _preferences;
    final value = preferences.getBool(_sfx);
    return value != null ? value : true;
  }
}

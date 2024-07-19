import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveController {
  static const String _scanValueKey = 'scan_value';
  static const String _isLoggedInKey = 'is_logged_in';
  static const int _countOn = 0;

  static Future<void> saveLogin(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scanValueKey, value);
  }

  static Future<String?> readLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_scanValueKey);
  }

  static Future<void> saveIsLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<bool> readIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> saveCountdownToSharedPreferences(
      int alarmIndex, int countdown) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("countdown_$alarmIndex", countdown);
  }

  static Future<int> loadCountdownFromSharedPreferences(int alarmIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? countdown = prefs.getInt("countdown_$alarmIndex");
    return countdown ?? 0;
  }

  static Future<void> removeCountdownFromSharedPreferences(
      int alarmIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("countdown_$alarmIndex");
  }

  static Future<void> saveCountOn(int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("_countOn", count);
  }

  static Future<int> readCountOn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("_countOn") ?? 0;
  }
}

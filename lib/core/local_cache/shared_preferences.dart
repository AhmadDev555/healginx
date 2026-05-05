import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClient {

  SharedPreferencesClient._();

  static final SharedPreferencesClient _instance = SharedPreferencesClient._();
  static SharedPreferencesClient get instance => _instance;


  /// =========================
  /// SAVE LOGIN STATUS
  /// =========================
  Future<void> setLoggedIn(bool value) async {
    SharedPreferencesAsync sharedPreferences = SharedPreferencesAsync();
    await sharedPreferences.setBool('is_logged_in', value);
  }

  Future<bool> isLoggedIn() async {
    SharedPreferencesAsync sharedPreferences = SharedPreferencesAsync();
    return await sharedPreferences.getBool('is_logged_in',)??false;
  }

  Future<void> clear() async {
    SharedPreferencesAsync sharedPreferences = SharedPreferencesAsync();
    await sharedPreferences.clear();
  }

}
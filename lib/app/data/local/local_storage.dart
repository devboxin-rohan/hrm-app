import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setToken(token) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("token", token);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    String token = prefs.getString("token") ?? "";
    return token;
  }

   void setTokenTime(token) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("token_time", token);
  }

  Future<int> getTokenTime() async {
    final SharedPreferences prefs = await _prefs;
    int token = prefs.getInt("token_time") ?? 0;
    return token;
  }
}

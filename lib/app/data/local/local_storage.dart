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

    void setDeviceId(token) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("device_id", token);
  }

  Future<String> getDeviceId() async {
    final SharedPreferences prefs = await _prefs;
    String token = prefs.getString("device_id") ?? "";
    return token;
  }


  Future<dynamic> setDashboardDetail(data) async {
    final SharedPreferences prefs = await _prefs;
    String stringData = jsonEncode(data);
    prefs.setString("dashboard_detail", stringData);
    return true;
  }

  Future<dynamic> getDashboardDetail() async {
    final SharedPreferences prefs = await _prefs;
    String dasboardData = prefs.getString("dashboard_detail") ?? "";
    return jsonDecode(dasboardData);
  }

}

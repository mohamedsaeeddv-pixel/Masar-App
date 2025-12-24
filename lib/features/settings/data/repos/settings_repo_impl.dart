import 'dart:convert';
import '../models/settings_model.dart';
import 'settings_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepoImpl implements SettingsRepo {
  static const String _settingsKey = 'user_settings';

  @override
  Future<SettingsModel> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_settingsKey);

    if (jsonString != null) {
      return SettingsModel.fromJson(jsonDecode(jsonString));
    }
    return SettingsModel(fontSize: 'متوسط', themeMode: 'فاتح', language: 'ar');
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }
}
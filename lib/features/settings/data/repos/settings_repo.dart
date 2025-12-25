
import '../models/settings_model.dart';

abstract class SettingsRepo {
  // جلب كل الإعدادات مرة واحدة
  Future<SettingsModel> getSettings();

  // حفظ الإعدادات كاملة
  Future<void> saveSettings(SettingsModel settings);
}
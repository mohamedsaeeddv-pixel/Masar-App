import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/settings_model.dart';
import '../../data/repos/settings_repo.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepo settingsRepo;

  SettingsCubit(this.settingsRepo) : super(SettingsInitial());

  // جلب الإعدادات من الـ Repo (SharedPreferences)
  Future<void> loadSettings() async {
    emit(SettingsLoading());
    try {
      final settings = await settingsRepo.getSettings();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError("فشل في تحميل الإعدادات"));
    }
  }

  // تحديث الإعدادات وحفظها
  Future<void> updateSettings(SettingsModel newSettings) async {
    try {
      await settingsRepo.saveSettings(newSettings);
      emit(SettingsUpdated(newSettings));
    } catch (e) {
      emit(SettingsError("فشل في حفظ التعديلات"));
    }
  }
}
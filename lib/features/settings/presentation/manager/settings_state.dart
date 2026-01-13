import '../../data/models/settings_model.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}
class SettingsLoading extends SettingsState {}
class SettingsError extends SettingsState { final String message; SettingsError(this.message); }

// كلاس أساسي لأي حالة فيها بيانات الإعدادات
class SettingsDataState extends SettingsState {
  final SettingsModel settings;
  SettingsDataState(this.settings);
}

class SettingsLoaded extends SettingsDataState {
  SettingsLoaded(super.settings);
}

class SettingsUpdated extends SettingsDataState {
  SettingsUpdated(super.settings);
}
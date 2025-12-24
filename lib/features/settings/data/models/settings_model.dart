class SettingsModel {
  final String fontSize;
  final String themeMode;
  final String language;

  SettingsModel({
    required this.fontSize,
    required this.themeMode,
    required this.language,
  });

  // تحويل من JSON (عشان لما نقرأ من الـ SharedPreferences)
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      fontSize: json['fontSize'] ?? 'متوسط',
      themeMode: json['themeMode'] ?? 'فاتح',
      language: json['language'] ?? 'ar',
    );
  }

  // تحويل لـ JSON (عشان لما نخزن في الـ SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'themeMode': themeMode,
      'language': language,
    };
  }
}
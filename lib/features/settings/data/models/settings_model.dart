class SettingsModel {
  final String fontSize;
  final String themeMode;
  final String language;

  SettingsModel({
    required this.fontSize,
    required this.themeMode,
    required this.language,
  });

  // 1. الـ Getter اللي هيحل مشكلة الـ Login
  double get fontSizeFactor {
    switch (fontSize) {
      case 'كبير':
        return 1.25; // تكبير بنسبة 25%
      case 'صغير':
        return 0.85; // تصغير بنسبة 15%
      default:
        return 1.0;  // الحجم الطبيعي للمتوسط
    }
  }

  // 2. ميثود copyWith عشان نحدث قيمة واحدة ونسيب الباقي (مهمة جداً للـ Cubit)
  SettingsModel copyWith({
    String? fontSize,
    String? themeMode,
    String? language,
  }) {
    return SettingsModel(
      fontSize: fontSize ?? this.fontSize,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      fontSize: json['fontSize'] ?? 'متوسط',
      themeMode: json['themeMode'] ?? 'فاتح',
      language: json['language'] ?? 'ar',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'themeMode': themeMode,
      'language': language,
    };
  }
}
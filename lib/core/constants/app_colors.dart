import 'package:flutter/material.dart';

abstract class AppColors {
  // --- الأكواد القديمة كما هي (لا تلمسها) ---
  static const backgroundLight = Color(0xFFEEEEEE);
  static const backgroundWhite = Color(0xFFFFFFFF);
  static const mutedBackground = Color(0xFFF5F5F5);

  static const textPrimaryDark = Color(0xFF212121);
  static const textMutedGray = Color(0xFF616161);
  static const textOnPrimary = Color(0xFFFFFFFF);
  static const textGreen = Color(0xFF4CAF50);
  static const textOrange = Color(0xFFFF9800);
  static const textRed = Color(0xFFD32F2F);
  static const textBlue = Color(0xFF2196F3);

  static const cardBackground = Color(0xFFFFFFFF);
  static const popoverBackground = Color(0xFFFFFFFF);

  static const bluePrimaryDark = Color(0xFF0D47A1);
  static const blueRing = Color(0xFF0D47A1);
  static const blueButton = Color(0xFF2196F3);
  static const bluePrimaryLight = Color(0xFFEFF6FF);
  static const blueSecondaryLightForBorder = Color(0XFFBEDBFF);

  static const cyanSecondary = Color(0xFF00ACC1);
  static const amberAccent = Color(0xFFFFC107);
  static const redDestructive = Color(0xFFD32F2F);

  static const borderLight = Color.fromRGBO(0, 0, 0, 0.12);
  static const inputBorder = Color.fromRGBO(0, 0, 0, 0.23);
  static const inputBackground = Color(0xFFFFFFFF);
  static const switchBackground = Color(0xFFCBCED4);

  static const chartBlue = Color(0xFF0D47A1);
  static const chartCyan = Color(0xFF00ACC1);
  static const chartAmber = Color(0xFFFFC107);
  static const chartGray = Color(0xFF616161);
  static const chartDark = Color(0xFF212121);

  static const sidebarBackground = Color(0xFFFFFFFF);
  static const sidebarText = Color(0xFF212121);
  static const sidebarPrimary = Color(0xFF0D47A1);
  static const sidebarPrimaryText = Color(0xFFFFFFFF);
  static const sidebarAccentBackground = Color(0xFFF5F5F5);
  static const sidebarBorder = Color.fromRGBO(0, 0, 0, 0.12);

  static const green = Color(0xFF4CAF50);
  static const lightGreenBackground = Color(0x1F4CAF50);
  static const orange = Color(0xFFFF9800);
  static const blue = Color(0xFF2196F3);
  static const red = Color(0xFFD32F2F);
  static const grayText = Color(0xFF757575);
  static const lightOrangeBackground = Color(0xFFFFF7ED);

  /* ============================================================= */
  /* --- التعديل الجديد لدعم الـ Dark Mode دون مسح القديم --- */
  /* ============================================================= */

  // دالة لمعرفة هل التطبيق في وضع الـ Dark حالياً
  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  // خلفية الشاشة (Dynamic)
  static Color scaffoldBackground(BuildContext context) =>
      isDark(context) ? const Color(0xFF121212) : backgroundLight;

  // خلفية الكروت (Dynamic)
  static Color itemCardBackground(BuildContext context) =>
      isDark(context) ? const Color(0xFF1E1E1E) : cardBackground;

  // لون النص الأساسي (Dynamic)
  static Color primaryText(BuildContext context) =>
      isDark(context) ? Colors.white : textPrimaryDark;

  // لون النص الثانوي (Dynamic)
  static Color secondaryText(BuildContext context) =>
      isDark(context) ? Colors.white70 : textMutedGray;

  // لون الحدود (Dynamic)
  static Color borderColor(BuildContext context) =>
      isDark(context) ? Colors.white12 : borderLight;
  static const Color surfaceDark = Color(0xFF1E1E1E); // لون الكروت في الداكن
}
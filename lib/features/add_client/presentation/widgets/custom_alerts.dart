import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // للترجمة
import '../../../../core/constants/app_colors.dart';

class CustomAlerts {

  // دالة مساعدة لجلب الـ Font Factor من الـ Context
  static double _getFontFactor(BuildContext context) {
    // بما إننا بننادي الـ Alerts من أماكن كتير، بنجيب الـ TextScaleFactor الحالي
    return MediaQuery.of(context).textScaleFactor;
  }

  // 1. SnackBar الموحد
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    final fontFactor = _getFontFactor(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message, // الرسالة بتيجي مترجمة جاهزة من الـ Cubit أو الـ Screen
          style: TextStyle(fontSize: 14 * fontFactor),
        ),
        backgroundColor: isError ? AppColors.redDestructive : AppColors.bluePrimaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // 2. Loading Dialog الموحد
  static void showLoadingDialog(BuildContext context) {
    final fontFactor = _getFontFactor(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60, width: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      isDarkMode ? Colors.blue[300]! : AppColors.bluePrimaryDark
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "common.processing".tr(), // ترجمة: "جاري المعالجة..."
                style: TextStyle(
                  fontSize: 16 * fontFactor,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.blue[200] : AppColors.bluePrimaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. Success Dialog الموحد
  static void showSuccessDialog(BuildContext context, String message) {
    final fontFactor = _getFontFactor(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha:  0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.green, size: 50),
              ),
              const SizedBox(height: 20),
              Text(
                "common.success_title".tr(), // ترجمة: "تمت العملية"
                style: TextStyle(
                  fontSize: 20 * fontFactor,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message, // الرسالة اللي جاية من الـ Success state
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14 * fontFactor,
                  color: isDarkMode ? Colors.grey[400] : AppColors.textMutedGray,
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bluePrimaryDark,
                  foregroundColor: AppColors.textOnPrimary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  "common.continue".tr(), // ترجمة: "استمرار"
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * fontFactor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
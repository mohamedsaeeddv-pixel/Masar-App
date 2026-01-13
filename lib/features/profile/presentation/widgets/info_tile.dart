import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final double fontFactor; // إضافة الـ fontFactor

  const InfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.fontFactor = 1.0, // القيمة الافتراضية
  });

  @override
  Widget build(BuildContext context) {
    // التحقق من حالة الـ Dark Mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      // التعديل هنا ليدعم اتجاه اللغة تلقائياً (Leading يتبدل مع Trailing)
      leading: Icon(icon, color: AppColors.bluePrimaryDark),
      title: Text(
        title,
        style: AppTextStyles.body14Regular.copyWith(
          color: isDarkMode ? Colors.grey[400] : AppColors.textMutedGray,
          fontSize: 14 * fontFactor, // تطبيق حجم الخط
        ),
      ),
      subtitle: Text(
        value,
        style: AppTextStyles.body16Bold.copyWith(
          color: isDarkMode ? Colors.white : AppColors.textPrimaryDark,
          fontSize: 16 * fontFactor, // تطبيق حجم الخط
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class StatsCard extends StatelessWidget {
  final String value;
  final String label;
  final double fontFactor; // إضافة الـ fontFactor لتوحيد النظام

  const StatsCard({
    super.key,
    required this.value,
    required this.label,
    this.fontFactor = 1.0, // القيمة الافتراضية 1.0
  });

  @override
  Widget build(BuildContext context) {
    // التحقق من حالة الـ Dark Mode لضبط ألوان الخلفية والنصوص
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        // في الـ Dark Mode نستخدم surfaceDark عشان الكارت ميبقاش "فقع" أبيض
        color: isDarkMode ? AppColors.surfaceDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.subtitle18Bold.copyWith(
              color: AppColors.bluePrimaryDark,
              fontSize: 18 * fontFactor, // تطبيق حجم الخط
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body14Regular.copyWith(
              color: isDarkMode ? Colors.grey[400] : AppColors.textMutedGray,
              fontSize: 14 * fontFactor, // تطبيق حجم الخط
            ),
          ),
        ],
      ),
    );
  }
}
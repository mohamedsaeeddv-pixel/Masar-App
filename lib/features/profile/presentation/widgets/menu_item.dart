import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_styles.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;
  final double fontFactor; // إضافة الـ fontFactor لتوحيد النظام

  const MenuItem({
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
    this.fontFactor = 1.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

      // 1. الأيقونة الملونة (تلقائياً على اليمين في العربي والشمال في الإنجليزي)
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDarkMode ? iconColor.withOpacity(0.15) : iconBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),

      // 2. النص (بدون Align يدوي عشان يقلب لوحده)
      title: Text(
        title,
        style: AppTextStyles.body16SemiBold.copyWith(
          color: isDarkMode ? Colors.white : AppColors.textPrimaryDark,
          fontSize: 16 * fontFactor,
        ),
      ),

      // 3. السهم (تلقائياً في الجهة المقابلة)
      // نستخدم Icons.chevron_right عشان الـ ListTile بيعمله Mirror تلقائي في الـ RTL
      trailing: Icon(
        Icons.chevron_right,
        size: 18,
        color: isDarkMode ? Colors.grey[600] : AppColors.textMutedGray,
      ),
    );
  }
}
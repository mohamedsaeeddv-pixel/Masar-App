import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String role;
  final double fontFactor; // إضافة الـ fontFactor لتوحيد حجم الخط

  const ProfileHeader({
    super.key,
    required this.name,
    this.role = "مندوب مبيعات",
    this.fontFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // التحقق من حالة الـ Dark Mode لضبط ألوان النصوص
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // الدائرة الأساسية للصورة
            CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.bluePrimaryDark,
              child: Icon(
                  Icons.person,
                  color: isDarkMode ? Colors.white : AppColors.textOnPrimary,
                  size: 40
              ),
            ),
            // نقطة الحالة (أونلاين)
            Positioned(
              bottom: 4,
              // استخدمنا right مع Directionality لضمان ظهورها صح في العربي والإنجليزي
              right: Directionality.of(context) == TextDirection.rtl ? 4 : null,
              left: Directionality.of(context) == TextDirection.ltr ? 4 : null,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.surfaceDark : AppColors.backgroundWhite,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // اسم المندوب
        Text(
          name,
          textAlign: TextAlign.center,
          style: AppTextStyles.title20Bold.copyWith(
            color: isDarkMode ? Colors.white : AppColors.textPrimaryDark,
            fontSize: 20 * fontFactor,
          ),
        ),
        const SizedBox(height: 4),
        // الوظيفة أو الدور
        Text(
          role,
          textAlign: TextAlign.center,
          style: AppTextStyles.body14Regular.copyWith(
            color: isDarkMode ? Colors.grey[400] : AppColors.textMutedGray,
            fontSize: 14 * fontFactor,
          ),
        ),
      ],
    );
  }
}
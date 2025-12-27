import 'package:flutter/material.dart';
// تأكد من تعديل المسارات لتناسب مشروعك
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class OptionCard extends StatelessWidget {
  final String label;
  final String? subLabel;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.subLabel,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            // استخدام ألوان الـ Core
            color: isSelected
                ? AppColors.bluePrimaryDark.withValues(alpha: 0.08)
                : AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.bluePrimaryDark : AppColors.borderLight,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // عرض الأيقونة إذا وجدت
              if (icon != null)
                Icon(
                  icon,
                  color: isSelected ? AppColors.bluePrimaryDark : AppColors.textMutedGray,
                  size: 24,
                ),
              // عرض النص الكبير (مثل Aa) إذا وجد
              if (subLabel != null)
                Text(
                  subLabel!,
                  style: AppTextStyles.subtitle18Bold.copyWith(
                    color: isSelected ? AppColors.bluePrimaryDark : AppColors.textPrimaryDark,
                  ),
                ),
              const SizedBox(height: 6),
              // الوصف (مثل صغير، فاتح، إلخ)
              Text(
                label,
                style: AppTextStyles.body14Regular.copyWith(
                  color: isSelected ? AppColors.bluePrimaryDark : AppColors.textMutedGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
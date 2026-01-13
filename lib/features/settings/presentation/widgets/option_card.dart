import 'package:flutter/material.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            // خلفية افتح شوية في الدارك مود عشان تبرز عن خلفية الصفحة
            color: isSelected
                ? AppColors.bluePrimaryDark.withOpacity(isDark ? 0.25 : 0.1)
                : (isDark ? const Color(0xFF252525) : Colors.white),
            borderRadius: BorderRadius.circular(16), // حواف دائرية أكتر بتدي شكل ألطف
            border: Border.all(
              color: isSelected
                  ? AppColors.bluePrimaryDark
                  : (isDark ? Colors.white.withOpacity(0.05) : AppColors.borderLight),
              width: isSelected ? 2 : 1,
            ),
            // إضافة ظل خفيف جداً لإعطاء عمق
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppColors.bluePrimaryDark.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: isSelected
                      ? (isDark ? Colors.blueAccent : AppColors.bluePrimaryDark)
                      : (isDark ? Colors.white38 : AppColors.textMutedGray),
                  size: 28, // كبرنا الأيقونة سنة
                ),
              if (subLabel != null)
                Text(
                  subLabel!,
                  style: AppTextStyles.subtitle18Bold.copyWith(
                    fontSize: 20, // كبرنا Aa شوية
                    color: isSelected
                        ? (isDark ? Colors.white : AppColors.bluePrimaryDark)
                        : (isDark ? Colors.white70 : AppColors.textPrimaryDark),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.body14Regular.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? (isDark ? Colors.white : AppColors.bluePrimaryDark)
                      : (isDark ? Colors.white38 : AppColors.textMutedGray),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
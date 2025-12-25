import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

// presentation/widgets/settings_section.dart

// settings_section.dart
class SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const SettingsSection({
    required this.title,
    required this.icon,
    required this.child,
    super.key
  });

  @override
// settings_section.dart
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      // إجبار القسم كله يتبع نظام اليمين للشمال
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Start هنا يعني اليمين في الـ RTL
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.bluePrimaryDark, size: 22),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTextStyles.body16Bold.copyWith(color: AppColors.textPrimaryDark),
                ),
              ],
            ),
            const Divider(height: 32, thickness: 0.5, color: AppColors.borderLight),
            child,
          ],
        ),
      ),
    );
  }
}
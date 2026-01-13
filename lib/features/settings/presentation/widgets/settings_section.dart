import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const SettingsSection({
    required this.title,
    required this.icon,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.bluePrimaryDark, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.body16Bold.copyWith(
                  color: isDarkMode ? Colors.white : AppColors.textPrimaryDark,
                ),
              ),
            ],
          ),
          Divider(
            height: 32,
            thickness: 0.5,
            color: isDarkMode ? Colors.white10 : AppColors.borderLight,
          ),
          child,
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
// استيراد الـ Core
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class StatsCard extends StatelessWidget {
  final String value;
  final String label;

  const StatsCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground, // Core color
        borderRadius: BorderRadius.circular(12),
        // إضافة shadow بسيط عشان يبرز الكارت زي ما عملنا في الـ Daily Tasks
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.subtitle18Bold.copyWith(
              color: AppColors.bluePrimaryDark, // Core color
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body14Regular.copyWith(
              color: AppColors.textMutedGray, // Core color
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class AppInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const AppInfoItem({
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.body14SemiBold.copyWith(
                  color: AppColors.textMutedGray,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.body14Regular.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.borderLight,
          ),
        ],
      ),
    );
  }
}
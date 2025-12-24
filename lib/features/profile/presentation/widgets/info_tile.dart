import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const InfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.bluePrimaryDark),
      title: Text(
        title,
        style: AppTextStyles.body14Regular.copyWith(color: AppColors.textMutedGray),
      ),
      subtitle: Text(
        value, // ستعرض القيمة القادمة من Firestore
        style: AppTextStyles.body16Bold.copyWith(color: AppColors.textPrimaryDark),
      ),
    );
  }
}
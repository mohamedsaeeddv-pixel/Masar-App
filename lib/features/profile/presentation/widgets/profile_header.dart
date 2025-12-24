import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String name; // أضف هذا السطر

  const ProfileHeader({super.key, required this.name}); // اجعلها مطلوبة هنا

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.bluePrimaryDark,
              child: Icon(Icons.person, color: AppColors.textOnPrimary, size: 40),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(color: AppColors.backgroundWhite, shape: BoxShape.circle),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          name, // استخدم المتغير هنا بدل "محمد أحمد"
          style: AppTextStyles.title20Bold.copyWith(color: AppColors.textPrimaryDark),
        ),
        const SizedBox(height: 4),
        Text(
          'ID: #88231', // ممكن تمرر الـ ID كمان بنفس الطريقة لو حبيت
          style: AppTextStyles.body14Regular.copyWith(color: AppColors.textMutedGray),
        ),
      ],
    );
  }
}
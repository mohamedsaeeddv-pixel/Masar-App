import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String role; // أضفنا الـ role هنا عشان تظهر تحت الاسم

  const ProfileHeader({
    super.key,
    required this.name,
    this.role = "مندوب مبيعات", // قيمة افتراضية
  });

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
                decoration: const BoxDecoration(
                  color: AppColors.backgroundWhite,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
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
        const SizedBox(height: 12),
        Text(
          name,
          style: AppTextStyles.title20Bold.copyWith(color: AppColors.textPrimaryDark),
        ),
        const SizedBox(height: 4),
        // استبدلنا الـ ID الثابت بالـ role اللي جاي من الداتا
        Text(
          role,
          style: AppTextStyles.body14Regular.copyWith(color: AppColors.textMutedGray),
        ),
      ],
    );
  }
}
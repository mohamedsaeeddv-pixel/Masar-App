// features/profile/presentation/widgets/menu_item.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_styles.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  const MenuItem({
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      // تأكد إن الـ ListTile بيحترم اتجاه اللغة
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),

      // 1. السهم (على الشمال في العربي)
      leading: const Icon(
        Icons.arrow_back_ios_new,
        size: 14, // صغرنا الحجم شوية ليكون أرق زي الصورة
        color: AppColors.textMutedGray,
      ),

      // 2. النص (في النص مائل لليمين)
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: AppTextStyles.body16SemiBold.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
      ),

      // 3. الأيقونة الملونة (على اليمين في العربي)
      trailing: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(10), // خليناها 10 عشان تبان أنعم
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }
}
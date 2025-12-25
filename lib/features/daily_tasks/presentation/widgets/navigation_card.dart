import 'package:flutter/material.dart';
// تأكد من صحة مسار استيراد ملف الـ core
import '../../../../core/constants/app_colors.dart';

class NavigationCard extends StatelessWidget {
  const NavigationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground, // استخدام مسمى الكروت من الـ Core
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // حالة الملاحة (Badge)
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.bluePrimaryDark, // اللون الأساسي الأزرق
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'جاهز للملاحة ●',
                style: TextStyle(
                  color: AppColors.textOnPrimary, // اللون الأبيض للنصوص فوق الأزرق
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // أيقونة الموقع (استخدمت اللون الـ Cyan كنوع من التغيير أو الـ Blue حسب الرغبة)
          const Icon(
            Icons.location_on_outlined,
            size: 70,
            color: AppColors.chartCyan, // لون ثانوي من الـ Core
          ),

          const Text(
            '4 عملاء في انتظارك',
            style: TextStyle(
              color: AppColors.textMutedGray, // النص الرمادي الباهت
              fontSize: 14,
            ),
          ),

          const Text(
            'ابدأ رحلة اليوم',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryDark, // النص الأساسي الغامق
            ),
          ),

          const SizedBox(height: 16),

          // زر بدء الملاحة
          ElevatedButton.icon(
            onPressed: () {
              // منطق فتح الخرائط
            },
            icon: const Icon(Icons.near_me_outlined),
            label: const Text('بدء الملاحة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bluePrimaryDark, // اللون الأزرق للزر
              foregroundColor: AppColors.textOnPrimary, // اللون الأبيض للكتابة
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
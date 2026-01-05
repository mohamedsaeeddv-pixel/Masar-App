import 'package:flutter/material.dart';
// استيراد الـ Core
import '../../../../core/constants/app_colors.dart';

class ProgressCard extends StatelessWidget {
        final int clientsLength;

  const ProgressCard({super.key, required this.clientsLength});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground, // من الـ Core
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'تقدم اليوم',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryDark, // من الـ Core
                ),
              ),
              Text(
                '0%',
                style: TextStyle(
                  color: AppColors.bluePrimaryDark, // من الـ Core
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // شريط التقدم
          LinearProgressIndicator(
            value: 0.05,
            backgroundColor: AppColors.mutedBackground, // اللون الباهت من الـ Core
            color: AppColors.bluePrimaryDark, // اللون الأساسي من الـ Core
            minHeight: 6,
            borderRadius: BorderRadius.circular(10), // لمسة جمالية
          ),
          const SizedBox(height: 8),
           Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '0/$clientsLength طلبات مكتملة',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMutedGray, // النص الرمادي من الـ Core
              ),
            ),
          ),
        ],
      ),
    );
  }
}
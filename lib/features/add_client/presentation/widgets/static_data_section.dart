import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class StaticDataSection extends StatelessWidget {
  const StaticDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.analytics_outlined, size: 20, color: AppColors.bluePrimaryDark),
              SizedBox(width: 10),
              Text(
                "بيانات ثابتة للنظام",
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.bluePrimaryDark),
              )
            ],
          ),
          const Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("إجمالي عدد الزيارات:"),
              Text("0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
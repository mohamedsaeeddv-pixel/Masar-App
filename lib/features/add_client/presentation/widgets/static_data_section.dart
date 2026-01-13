import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // للترجمة
import '../../../../core/constants/app_colors.dart';

class StaticDataSection extends StatelessWidget {
  final double fontFactor; // استقبال معامل الخط

  const StaticDataSection({
    super.key,
    this.fontFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد المظهر (Dark/Light)
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // خلفية ديناميكية: رمادي غامق جداً في الدارك مود
        color: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                  Icons.analytics_outlined,
                  size: 20 * fontFactor,
                  color: isDarkMode ? Colors.blue[200] : AppColors.bluePrimaryDark
              ),
              const SizedBox(width: 10),
              Text(
                "add_client.static_data_title".tr(), // ترجمة: "بيانات ثابتة للنظام"
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14 * fontFactor,
                    color: isDarkMode ? Colors.blue[200] : AppColors.bluePrimaryDark
                ),
              )
            ],
          ),
          Divider(height: 25, color: isDarkMode ? Colors.grey[700] : null),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "add_client.total_visits_label".tr(), // ترجمة: "إجمالي عدد الزيارات:"
                style: TextStyle(
                    fontSize: 14 * fontFactor,
                    color: isDarkMode ? Colors.grey[300] : Colors.black87
                ),
              ),
              Text(
                "0",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * fontFactor,
                    color: isDarkMode ? Colors.white : Colors.black
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CustomClientTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final double fontFactor; // استقبال معامل الخط من الأب

  const CustomClientTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.fontFactor = 1.0, // القيمة الافتراضية
  });

  @override
  Widget build(BuildContext context) {
    // تحديد هل المظهر الحالي داكن أم فاتح
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الـ Label الديناميكي
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15 * fontFactor, // تكبير الخط
              color: isDarkMode ? Colors.blue[200] : AppColors.bluePrimaryDark,
            ),
          ),
        ),

        // الـ TextField بتصميم يستجيب للمظهر
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            fontSize: 16 * fontFactor,
            color: isDarkMode ? Colors.white : Colors.black, // نص الكتابة
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: 14 * fontFactor,
                color: isDarkMode ? Colors.grey[500] : AppColors.textMutedGray
            ),
            filled: true,
            // تغيير لون الخلفية حسب المظهر
            fillColor: isDarkMode ? const Color(0xFF2C2C2C) : AppColors.backgroundWhite,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

            // الحدود في الوضع العادي
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: isDarkMode ? Colors.grey[700]! : AppColors.borderLight
              ),
            ),

            // الحدود عند التفاعل (Focus)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: isDarkMode ? Colors.blue[300]! : AppColors.bluePrimaryDark,
                  width: 2
              ),
            ),

            // حدود الخطأ (Error) تفضل واضحة
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.redDestructive),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.redDestructive, width: 2),
            ),

            // تحسين شكل رسالة الخطأ
            errorStyle: TextStyle(fontSize: 12 * fontFactor),
          ),
        ),
      ],
    );
  }
}
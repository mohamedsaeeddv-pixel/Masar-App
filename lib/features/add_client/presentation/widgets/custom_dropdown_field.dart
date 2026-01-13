import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // للترجمة
import '../../../../core/constants/app_colors.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final double fontFactor; // استقبال معامل الخط

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.fontFactor = 1.0, // الافتراضي
  });

  @override
  Widget build(BuildContext context) {
    // تحديد المظهر (Dark/Light)
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الـ Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15 * fontFactor,
              color: isDarkMode ? Colors.blue[200] : AppColors.bluePrimaryDark,
            ),
          ),
        ),

        // الـ Dropdown مع تصميم مستجيب
        DropdownButtonFormField<String>(
          initialValue: value,
          // تحديد لون خلفية القائمة عند فتحها
          dropdownColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          // أيقونة السهم بلون يتناسب مع المظهر
          iconEnabledColor: isDarkMode ? Colors.blue[200] : AppColors.bluePrimaryDark,
          isExpanded: true, // مهم جداً لمنع الـ Overflow عند تكبير الخط
          validator: (val) => val == null ? "common.choose_error".tr() : null,
          style: TextStyle(
            fontSize: 14 * fontFactor,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDarkMode ? const Color(0xFF2C2C2C) : AppColors.backgroundWhite,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: isDarkMode ? Colors.grey[700]! : AppColors.borderLight
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: isDarkMode ? Colors.blue[300]! : AppColors.bluePrimaryDark,
                  width: 2
              ),
            ),
            // حدود الخطأ
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.redDestructive),
            ),
          ),
          hint: Text(
              hint,
              style: TextStyle(
                  fontSize: 14 * fontFactor,
                  color: isDarkMode ? Colors.grey[500] : AppColors.textMutedGray
              )
          ),
          // العناصر داخل القائمة
          items: items.map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                overflow: TextOverflow.ellipsis, // حماية من النصوص الطويلة
              )
          )).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
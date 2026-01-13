import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // 1. للترجمة
import '../../../../core/constants/app_colors.dart';
import '../../data/client_constants.dart';

class AreaDropdownField extends StatelessWidget {
  final String? selectedArea;
  final ValueChanged<String?> onChanged;
  final double fontFactor; // 2. استقبال معامل الخط

  const AreaDropdownField({
    super.key,
    required this.selectedArea,
    required this.onChanged,
    this.fontFactor = 1.0, // القيمة الافتراضية
  });

  @override
  Widget build(BuildContext context) {
    final List<String> staticAreas = AddClientStaticData.areas;

    // 3. تحديد مظهر الألوان بناءً على الـ Theme (Dark/Light)
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "add_client.area_label".tr(), // ترجمة: "المنطقة الجغرافية *"
          style: TextStyle(
            fontSize: 14 * fontFactor, // خط ديناميكي
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.blue[200] : AppColors.bluePrimaryDark, // لون متوافق مع المظهر
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: staticAreas.contains(selectedArea) ? selectedArea : null,
          isExpanded: true, // مهم جداً عشان النص ما يخرجش بره
          hint: Text(
            "add_client.area_hint".tr(), // ترجمة: "اختر المنطقة"
            style: TextStyle(fontSize: 14 * fontFactor),
          ),
          style: TextStyle(
            fontSize: 14 * fontFactor,
            color: isDarkMode ? Colors.white : Colors.black, // نص ديناميكي
          ),
          dropdownColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white, // خلفية القائمة
          decoration: InputDecoration(
            filled: true,
            fillColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: isDarkMode ? const BorderSide(color: Colors.grey) : BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          // تحويل العناصر لنصوص مترجمة لو محتاج، أو عرضها كما هي لو كانت أسماء مناطق ثابتة
          items: staticAreas.map((area) => DropdownMenuItem(
            value: area,
            child: FittedBox( // إضافة FittedBox عشان النص يصغر سنة لو الزحمة زادت في الكرت
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                area,
                style: TextStyle(fontSize: 14 * fontFactor), // تأكيد الحجم هنا كمان
              ),
            ),
          )).toList(),
          onChanged: onChanged,
          validator: (val) => val == null ? "add_client.area_error".tr() : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
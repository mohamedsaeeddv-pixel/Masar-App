import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // للترجمة
import 'custom_client_text_field.dart';

class FinancialInfoSection extends StatelessWidget {
  final TextEditingController spentController;
  final TextEditingController visitsController;
  final double fontFactor; // استقبال معامل الخط

  const FinancialInfoSection({
    super.key,
    required this.spentController,
    required this.visitsController,
    this.fontFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // مهم جداً عشان لو الـ Label طول في حقل ميبوظش محاذاة التاني
      children: [
        Expanded(
          child: CustomClientTextField(
            label: "client_details.last_purchase".tr(), // ترجمة من الـ JSON
            hint: "0",
            controller: spentController,
            keyboardType: TextInputType.number,
            fontFactor: fontFactor, // تمرير المعامل
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: CustomClientTextField(
            label: "profile.completed_tasks".tr(), // استخدمنا مفاتيح مشابهة أو ضيف "num_visits" في الـ JSON
            hint: "1",
            controller: visitsController,
            keyboardType: TextInputType.number,
            fontFactor: fontFactor, // تمرير المعامل
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // للترجمة
import 'custom_client_text_field.dart';

class ClientNamesSection extends StatelessWidget {
  final TextEditingController nameArController;
  final TextEditingController nameEnController;
  final double fontFactor; // استقبال معامل الخط

  const ClientNamesSection({
    super.key,
    required this.nameArController,
    required this.nameEnController,
    this.fontFactor = 1.0, // افتراضي 1.0
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // حقل الاسم بالعربي
        CustomClientTextField(
          label: "add_client.name_ar_label".tr(), // "اسم العميل (بالعربي) *"
          hint: "add_client.name_ar_hint".tr(),   // "أدخل الاسم بالعربي"
          controller: nameArController,
          fontFactor: fontFactor, // تمرير المعامل للـ Widget الصغير
          validator: (val) {
            if (val == null || val.isEmpty) return "add_client.name_ar_required".tr();
            if (!RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(val)) {
              return "add_client.arabic_only_error".tr();
            }
            return null;
          },
        ),

        // حقل الاسم بالإنجليزي
        CustomClientTextField(
          label: "add_client.name_en_label".tr(), // "Client Name (English) *"
          hint: "add_client.name_en_hint".tr(),   // "Enter English Name"
          controller: nameEnController,
          fontFactor: fontFactor,
          validator: (val) {
            if (val == null || val.isEmpty) return "add_client.name_en_required".tr();
            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val)) {
              return "add_client.english_only_error".tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'custom_client_text_field.dart';

class ClientNamesSection extends StatelessWidget {
  final TextEditingController nameArController;
  final TextEditingController nameEnController;

  const ClientNamesSection({
    super.key,
    required this.nameArController,
    required this.nameEnController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomClientTextField(
          label: "اسم العميل (بالعربي) *",
          hint: "أدخل الاسم بالعربي",
          controller: nameArController,
          validator: (val) {
            if (val == null || val.isEmpty) return "الاسم بالعربي مطلوب";
            if (!RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(val)) {
              return "يرجى إدخال حروف عربية فقط";
            }
            return null;
          },
        ),
        CustomClientTextField(
          label: "Client Name (English) *",
          hint: "Enter English Name",
          controller: nameEnController,
          validator: (val) {
            if (val == null || val.isEmpty) return "English name is required";
            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val)) {
              return "Please enter English letters only";
            }
            return null;
          },
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CustomClientTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomClientTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الـ Label باستخدام متغير اللون
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.bluePrimaryDark, // اللون الموحد
            ),
          ),
        ),
        // الـ TextField بتصميمه الموحد
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, color: AppColors.textMutedGray),
            filled: true,
            fillColor: AppColors.backgroundWhite,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            // الحدود العادية
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            // الحدود عند الضغط (Focus) باستخدام متغير اللون
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.bluePrimaryDark, width: 2),
            ),
            // الحدود في حالة الخطأ
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.redDestructive),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.redDestructive, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
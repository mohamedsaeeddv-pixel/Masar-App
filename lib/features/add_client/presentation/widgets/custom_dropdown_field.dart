import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        DropdownButtonFormField<String>(
          value: value,
          validator: (val) => val == null ? "يرجى الاختيار" : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.backgroundWhite,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.bluePrimaryDark, width: 2),
            ),
          ),
          hint: Text(hint, style: const TextStyle(fontSize: 14, color: AppColors.textMutedGray)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
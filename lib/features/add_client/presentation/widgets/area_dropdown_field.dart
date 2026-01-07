import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/client_constants.dart'; // عشان يقرأ AddClientStaticData

class AreaDropdownField extends StatelessWidget {
  final String? selectedArea;
  final ValueChanged<String?> onChanged;

  const AreaDropdownField({
    super.key,
    required this.selectedArea,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // هنستخدم القائمة اللي إنت بعتها في الـ AddClientStaticData
    final List<String> staticAreas = AddClientStaticData.areas;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "المنطقة الجغرافية *",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.bluePrimaryDark),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: staticAreas.contains(selectedArea) ? selectedArea : null,
          isExpanded: true,
          hint: const Text("اختر المنطقة"),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          // بنعرض البيانات اللي في AddClientStaticData
          items: staticAreas.map((area) => DropdownMenuItem(value: area, child: Text(area))).toList(),
          onChanged: onChanged,
          validator: (val) => val == null ? "المنطقة مطلوبة" : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
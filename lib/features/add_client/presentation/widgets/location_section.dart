import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LocationPickerSection extends StatelessWidget {
  final VoidCallback onLocationPressed;
  final TextEditingController latController;
  final TextEditingController lngController;

  const LocationPickerSection({
    super.key,
    required this.onLocationPressed,
    required this.latController,
    required this.lngController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0, top: 16.0),
          child: Text(
            "الموقع *",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.bluePrimaryDark,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: onLocationPressed,
          icon: const Icon(Icons.my_location),
          label: const Text("تحديد موقعي الحالي", style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.amberAccent, // اللون الأصفر من ملفك
            foregroundColor: AppColors.textPrimaryDark, // اللون الغامق للنص
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 2,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            _buildSmallField("خط العرض", latController),
            const SizedBox(width: 15),
            _buildSmallField("خط الطول", lngController),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallField(String label, TextEditingController controller) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(" $label",
            style: const TextStyle(fontSize: 12, color: AppColors.textMutedGray, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.mutedBackground, // رمادي خفيف للخلفية
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ]),
    );
  }
}
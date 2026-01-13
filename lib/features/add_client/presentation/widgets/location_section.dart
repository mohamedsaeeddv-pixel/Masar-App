import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // للترجمة
import '../../../../core/constants/app_colors.dart';

class LocationPickerSection extends StatelessWidget {
  final VoidCallback onLocationPressed;
  final TextEditingController latController;
  final TextEditingController lngController;
  final double fontFactor; // استقبال معامل الخط

  const LocationPickerSection({
    super.key,
    required this.onLocationPressed,
    required this.latController,
    required this.lngController,
    this.fontFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
          child: Text(
            "client_details.location".tr() + " *", // ترجمة: "الموقع *"
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15 * fontFactor,
              color: isDarkMode ? Colors.blue[200] : AppColors.bluePrimaryDark,
            ),
          ),
        ),

        // زرار التقاط الموقع
        ElevatedButton.icon(
          onPressed: onLocationPressed,
          icon: const Icon(Icons.my_location),
          label: Text(
            "add_client.detect_location".tr(), // ترجمة: "تحديد موقعي الحالي"
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14 * fontFactor,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.amberAccent,
            foregroundColor: AppColors.textPrimaryDark,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 2,
          ),
        ),

        const SizedBox(height: 15),

        // حقول خطوط الطول والعرض
        Row(
          children: [
            _buildSmallField(
              "add_client.lat".tr(), // ترجمة: "خط العرض"
              latController,
              isDarkMode,
            ),
            const SizedBox(width: 15),
            _buildSmallField(
              "add_client.long".tr(), // ترجمة: "خط الطول"
              lngController,
              isDarkMode,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallField(String label, TextEditingController controller, bool isDarkMode) {
    return Expanded(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " $label",
              style: TextStyle(
                  fontSize: 12 * fontFactor,
                  color: isDarkMode ? Colors.grey[400] : AppColors.textMutedGray,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: controller,
              readOnly: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13 * fontFactor,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: isDarkMode ? const Color(0xFF2C2C2C) : AppColors.mutedBackground,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: isDarkMode ? BorderSide(color: Colors.grey[700]!) : BorderSide.none
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ]
      ),
    );
  }
}
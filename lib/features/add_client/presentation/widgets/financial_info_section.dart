import 'package:flutter/material.dart';
import 'custom_client_text_field.dart';

class FinancialInfoSection extends StatelessWidget {
  final TextEditingController spentController;
  final TextEditingController visitsController;

  const FinancialInfoSection({
    super.key,
    required this.spentController,
    required this.visitsController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomClientTextField(
            label: "إجمالي المدفوعات",
            hint: "0",
            controller: spentController,
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: CustomClientTextField(
            label: "عدد الزيارات",
            hint: "1",
            controller: visitsController,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
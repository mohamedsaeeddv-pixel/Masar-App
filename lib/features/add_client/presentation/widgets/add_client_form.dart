import 'package:flutter/material.dart';

class AddClientForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  // ... باقي الـ Controllers

  const AddClientForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildTextField("اسم العميل", nameController),
          const SizedBox(height: 15),
          _buildTextField("رقم الهاتف", phoneController, isPhone: true),
          // هتحط هنا باقي الحقول اللي فصصناها في الكود القديم
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPhone = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (val) => val!.isEmpty ? "هذا الحقل مطلوب" : null,
    );
  }
}
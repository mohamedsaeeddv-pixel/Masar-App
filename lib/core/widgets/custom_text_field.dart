import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textAlign: TextAlign.right,
      obscureText: widget.isPassword ? obscure : false,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: Icon(widget.icon),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              obscure = !obscure;
            });
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String label;
  final String? sub;
  final IconData? icon;
  final String? flag;
  final bool selected;
  final VoidCallback? onTap;

  const OptionButton({
    super.key,
    required this.label,
    this.sub,
    this.icon,
    this.flag,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade300,
          ),
          color: selected ? Colors.blue.shade50 : Colors.transparent,
        ),
        child: Column(
          children: [
            if (icon != null) Icon(icon, size: 18),
            if (flag != null)
              Text(flag!, style: const TextStyle(fontSize: 18)),
            if (sub != null)
              Text(
                sub!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            Text(label),
          ],
        ),
      ),
    );
  }
}


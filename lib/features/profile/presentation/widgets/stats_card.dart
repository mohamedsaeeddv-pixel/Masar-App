import 'package:flutter/material.dart';
class StatsCard extends StatelessWidget {
  final String value;
  final String label;

  const StatsCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title, value, percent;
  final IconData icon;
  final Color iconColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.percent,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // الكلام كله يمين
          children: [
            Align(
              alignment: Alignment.centerRight, // الأيقونة يمين
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13), textAlign: TextAlign.right),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // السهم والنسبة يمين
              children: [
                Text(percent, style: TextStyle(color: iconColor, fontSize: 12, fontWeight: FontWeight.bold)),
                Icon(Icons.trending_up, color: iconColor, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
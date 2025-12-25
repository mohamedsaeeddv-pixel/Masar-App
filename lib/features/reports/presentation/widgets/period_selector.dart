import 'package:flutter/material.dart';

class PeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onSelect;

  const PeriodSelector({super.key, required this.selectedPeriod, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: ['يومي', 'أسبوعي', 'شهري'].map((p) => Expanded(
          child: GestureDetector(
            onTap: () => onSelect(p),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: selectedPeriod == p ? const Color(0xFF0D47A1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(p, style: TextStyle(color: selectedPeriod == p ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }
}
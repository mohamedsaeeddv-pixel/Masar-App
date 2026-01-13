import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onSelect;
  final double fontFactor;
  final bool isDarkMode;

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onSelect,
    required this.fontFactor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> periodLabels = {
      'يومي': 'reports.periods.daily'.tr(),
      'أسبوعي': 'reports.periods.weekly'.tr(),
      'شهري': 'reports.periods.monthly'.tr(),
    };

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isDarkMode ? Border.all(color: Colors.white10) : null,
      ),
      child: Row(
        children: ['يومي', 'أسبوعي', 'شهري'].map((p) {
          bool isSelected = selectedPeriod == p;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(p),
              // استعملنا AnimatedContainer عشان انتقال اللون يكون ناعم (Smooth)
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDarkMode ? Colors.blueAccent : const Color(0xFF0D47A1))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  // أنيميشن لتغيير لون النص برضه
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDarkMode ? Colors.white54 : Colors.grey),
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * fontFactor,
                      fontFamily: 'Cairo', // اتأكد إن الفونت موحد
                    ),
                    child: Text(periodLabels[p] ?? p),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
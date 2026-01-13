import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title, value, percent;
  final IconData icon;
  final Color iconColor;
  final double fontFactor; // إضافة بارامتر حجم الخط
  final bool isDarkMode;   // إضافة بارامتر الوضع الداكن

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.percent,
    required this.icon,
    required this.iconColor,
    required this.fontFactor, // مطلوب
    required this.isDarkMode, // مطلوب
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // تغيير لون الكارت بناءً على المود
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        // إضافة ظل خفيف في الفاتح فقط
        boxShadow: isDarkMode ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15), // زيادة الشفافية قليلاً للوضوح
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
          ),
          const SizedBox(height: 12),
          // ربط حجم الخط ولون العنوان
          Text(
              title,
              style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.grey,
                  fontSize: 13 * fontFactor
              ),
              textAlign: TextAlign.right
          ),
          // ربط حجم الخط ولون القيمة (الرقم)
          Text(
              value,
              style: TextStyle(
                  fontSize: 24 * fontFactor,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black
              ),
              textAlign: TextAlign.right
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                  percent,
                  style: TextStyle(
                      color: iconColor,
                      fontSize: 12 * fontFactor,
                      fontWeight: FontWeight.bold
                  )
              ),
              Icon(Icons.trending_up, color: iconColor, size: 14),
            ],
          ),
        ],
      ),
    );
  }
}
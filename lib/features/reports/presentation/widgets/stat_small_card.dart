import 'package:flutter/material.dart';

class StatSmallCard extends StatelessWidget {
  final String title, value, percent;
  final IconData icon;
  final double fontFactor;
  final bool isDarkMode;

  const StatSmallCard({
    super.key,
    required this.title,
    required this.value,
    required this.percent,
    required this.icon,
    required this.fontFactor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDarkMode ? [] : [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
        ],
        border: isDarkMode ? Border.all(color: Colors.white10) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: isDarkMode ? Colors.blueAccent.withOpacity(0.1) : Colors.blue.withOpacity(0.05),
                shape: BoxShape.circle
            ),
            child: Icon(
                icon,
                color: isDarkMode ? Colors.blueAccent : const Color(0xFF0D47A1),
                size: 20 * fontFactor
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey,
              fontSize: 11 * fontFactor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // --- تعديل الأنيميشن ليكون Slide لمنع الرعشة تماماً ---
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              // Tween بيخلي الرقم يدخل من تحت لفوق بنعومة
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(0.0, 0.4),
                end: Offset.zero,
              ).animate(animation);

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              );
            },
            child: Text(
              value,
              // الـ Key لازم يكون القيمة عشان الأنيميشن يلقط التغيير وقته
              key: ValueKey<String>(value),
              style: TextStyle(
                fontSize: 15 * fontFactor,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 4),
          Text(
            percent,
            style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 10 * fontFactor,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
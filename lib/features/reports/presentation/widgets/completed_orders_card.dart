import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CompletedOrdersCard extends StatelessWidget {
  final int completed;
  final int total;
  final double fontFactor;
  final bool isDarkMode;

  const CompletedOrdersCard({
    super.key,
    required this.completed,
    required this.total,
    required this.fontFactor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    double progress = total > 0 ? (completed / total) : 0;
    int percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDarkMode ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'reports.completed_orders_title'.tr(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16 * fontFactor,
                color: isDarkMode ? Colors.white : Colors.black87
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. سلايد أنيميشن للنسبة المئوية
              _buildAnimatedCounter(
                '$percentage% ↗',
                percentage,
                const TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  // 2. سلايد أنيميشن للرقم الحالي
                  _buildAnimatedCounter(
                    '$completed',
                    completed,
                    TextStyle(
                        fontSize: 28 * fontFactor,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.blueAccent : const Color(0xFF0D47A1)
                    ),
                  ),
                  Text(
                    '/$total',
                    style: TextStyle(
                        fontSize: 16 * fontFactor,
                        color: isDarkMode ? Colors.white38 : Colors.grey.shade400,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                  color: isDarkMode ? Colors.blueAccent : const Color(0xFF0D47A1),
                  minHeight: 8,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 3. سلايد أنيميشن لنص المتبقي
              _buildAnimatedCounter(
                'reports.remaining_text'.tr(args: [(total - completed).toString()]),
                total - completed,
                TextStyle(
                    color: isDarkMode ? Colors.white54 : Colors.grey.shade500,
                    fontSize: 12 * fontFactor
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.circle, size: 8, color: isDarkMode ? Colors.blueAccent : Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  // --- الميثود السحرية اللي بتعمل Slide بدل الـ Flicker ---
  Widget _buildAnimatedCounter(String text, dynamic value, TextStyle style) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        // بنعمل Tween يخلي النص يدخل من تحت لفوق (Slide Up)
        var offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0.5), // يبدأ من تحت شوية
          end: const Offset(0, 0),    // يستقر في مكانه
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
        text,
        key: ValueKey<String>(text), // استخدام النص كـ Key يضمن التحديث الفوري
        style: style,
      ),
    );
  }
}
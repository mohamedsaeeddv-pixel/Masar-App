import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class GoalProgressCard extends StatelessWidget {
  final int completed, total;
  final double sales, salesGoal;
  final String period;
  final double fontFactor;
  final bool isDarkMode;

  const GoalProgressCard({
    super.key,
    required this.completed,
    required this.total,
    required this.sales,
    required this.salesGoal,
    required this.period,
    required this.fontFactor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    double ordersProgress = (total > 0) ? (completed / total) : 0.0;
    double salesProgress = (salesGoal > 0) ? (sales / salesGoal) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A45A7) : const Color(0xFF1E63EE),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDarkMode ? [] : [
          BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSlideText(
                'reports.goal_title'.tr(args: [period]),
                period,
                TextStyle(color: Colors.white, fontSize: 20 * fontFactor, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.track_changes_outlined, color: Colors.white.withOpacity(0.9), size: 28),
            ],
          ),
          const SizedBox(height: 25),

          _buildProgressRow(
            label: 'reports.orders_count'.tr(),
            current: completed.toString(),
            target: total.toString(),
            progress: ordersProgress,
            color: Colors.white,
            unit: '',
            fontFactor: fontFactor,
            id: 'orders', // معرف فريد للأنيميشن
          ),

          const SizedBox(height: 25),

          _buildProgressRow(
            label: 'reports.sales_value'.tr(),
            current: sales.toInt().toString(),
            target: salesGoal.toInt().toString(),
            progress: salesProgress,
            color: Colors.amber,
            unit: 'reports.currency'.tr(),
            fontFactor: fontFactor,
            id: 'sales',
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSlideText(
                  'reports.remaining_goal'.tr(args: [(total - completed).toString()]),
                  total - completed,
                  TextStyle(color: Colors.white, fontSize: 14 * fontFactor),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.circle, color: Colors.amber, size: 10),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgressRow({
    required String label,
    required String current,
    required String target,
    required double progress,
    required Color color,
    required String unit,
    required double fontFactor,
    required String id,
  }) {
    final double safeProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 14 * fontFactor)),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _buildSlideText(
                '${(safeProgress * 100).toInt()}%',
                '${id}_percent_${(safeProgress * 100).toInt()}',
                TextStyle(color: Colors.white, fontSize: 13 * fontFactor, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                _buildSlideText(
                  current,
                  '${id}_current_$current',
                  TextStyle(color: Colors.white, fontSize: 28 * fontFactor, fontWeight: FontWeight.bold),
                ),
                Text(
                  '/$target',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16 * fontFactor),
                ),
                if (unit.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(unit, style: TextStyle(color: Colors.white, fontSize: 14 * fontFactor)),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // أنيميشن الشريط الملون
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: safeProgress),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.white.withOpacity(0.2),
                color: color,
                minHeight: 12,
              );
            },
          ),
        ),
      ],
    );
  }

  // ميثود الزحلقة (Slide) لمنع الرعشة
  Widget _buildSlideText(String text, dynamic valueKey, TextStyle style) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.4), // يدخل من تحت لفوق
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(text, key: ValueKey(valueKey.toString()), style: style),
    );
  }
}
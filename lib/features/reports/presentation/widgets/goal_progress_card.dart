import 'package:flutter/material.dart';

class GoalProgressCard extends StatelessWidget {
  final int completed, total;
  final double sales, salesGoal;
  final String period;

  const GoalProgressCard({
    super.key,
    required this.completed,
    required this.total,
    required this.sales,
    required this.salesGoal,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    // حسابات آمنة لضمان عدم حدوث خطأ في التقسيم أو عرض علامة X
    double ordersProgress = (total > 0) ? (completed / total) : 0.0;
    double salesProgress = (salesGoal > 0) ? (sales / salesGoal) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E63EE), // اللون الأزرق الزاهي طبقاً للصورة
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان العلوي مع الأيقونة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الهدف ال$period',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Icon(Icons.track_changes_outlined,
                  color: Colors.white.withValues(alpha: 0.9), size: 28),
            ],
          ),
          const SizedBox(height: 25),

          // قسم عدد الطلبات
          _buildProgressRow(
            label: 'عدد الطلبات',
            current: completed.toString(),
            target: total.toString(),
            progress: ordersProgress,
            color: Colors.white,
            unit: '',
          ),

          const SizedBox(height: 25),

          // قسم قيمة المبيعات
          _buildProgressRow(
            label: 'قيمة المبيعات',
            current: sales.toInt().toString(),
            target: salesGoal.toInt().toString(),
            progress: salesProgress,
            color: Colors.amber,
            unit: ' جنيه',
          ),

          const SizedBox(height: 20),

          // شريط المعلومات السفلي (متبقي X للوصول للهدف)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'متبقي ${total - completed} طلبات للوصول للهدف',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
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
  }) {
    // التأكد أن القيمة بين 0 و 1 لضمان استقرار الواجهة
    final double safeProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // كبسولة النسبة المئوية
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${(safeProgress * 100).toInt()}%',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            // عرض القيمة الحالية والمستهدفة
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                if (unit.isNotEmpty)
                  Text(unit, style: const TextStyle(color: Colors.white, fontSize: 14)),
                Text('/$target',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 16)),
                Text(current,
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // شريط التقدم بتصميم دائري الأطراف
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: safeProgress,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            color: color,
            minHeight: 12,
          ),
        ),
      ],
    );
  }
}
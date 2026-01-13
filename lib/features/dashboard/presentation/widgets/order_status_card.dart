import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math' as math;

class OrderStatusCard extends StatelessWidget {
  final double deliveredPercent;
  final double returnedPercent;
  final double failedPercent;
  final double fontFactor; // تم الإضافة
  final bool isDarkMode;   // تم الإضافة

  const OrderStatusCard({
    super.key,
    required this.deliveredPercent,
    required this.returnedPercent,
    required this.failedPercent,
    required this.fontFactor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد ألوان الرسم البياني بناءً على الوضع
    final Color deliveredColor = isDarkMode ? Colors.blueAccent : const Color(0xFF0D47A1);
    final Color returnedColor = isDarkMode ? Colors.orangeAccent : Colors.orange;
    final Color failedColor = isDarkMode ? Colors.redAccent : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // تغيير لون الكارت بناءً على الثيم
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDarkMode ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "dashboard.order_status".tr(), // ربط اللغة
            style: TextStyle(
              fontSize: 18 * fontFactor, // ربط الخط
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // الرسم البياني الملون
              SizedBox(
                height: 100,
                width: 100,
                child: CustomPaint(
                  painter: MultiColorPieChartPainter(
                    delivered: deliveredPercent,
                    returned: returnedPercent,
                    failed: failedPercent,
                    deliveredColor: deliveredColor,
                    returnedColor: returnedColor,
                    failedColor: failedColor,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ),
              // الليستة الجانبية
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusItem("dashboard.status_delivered".tr(), deliveredPercent, deliveredColor),
                  _buildStatusItem("dashboard.status_returned".tr(), returnedPercent, returnedColor),
                  _buildStatusItem("dashboard.status_failed".tr(), failedPercent, failedColor),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 8),
          Text(
              "$label: ",
              style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.grey,
                  fontSize: 12 * fontFactor
              )
          ),
          Text(
              "${value.toInt()}%",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 12 * fontFactor
              )
          ),
        ],
      ),
    );
  }
}

class MultiColorPieChartPainter extends CustomPainter {
  final double delivered, returned, failed;
  final Color deliveredColor, returnedColor, failedColor;
  final bool isDarkMode;

  MultiColorPieChartPainter({
    required this.delivered,
    required this.returned,
    required this.failed,
    required this.deliveredColor,
    required this.returnedColor,
    required this.failedColor,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 15;
    Rect rect = Offset.zero & size;

    // 1. رسم الخلفية الدائرية (تتغير حسب المود)
    Paint backgroundPaint = Paint()
      ..color = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * math.pi, false, backgroundPaint);

    // 2. رسم الأجزاء الملونة
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -math.pi / 2; // البداية من الأعلى

    if (delivered > 0) {
      double sweepAngle = (delivered / 100) * 2 * math.pi;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint..color = deliveredColor);
      startAngle += sweepAngle;
    }

    if (returned > 0) {
      double sweepAngle = (returned / 100) * 2 * math.pi;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint..color = returnedColor);
      startAngle += sweepAngle;
    }

    if (failed > 0) {
      double sweepAngle = (failed / 100) * 2 * math.pi;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint..color = failedColor);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
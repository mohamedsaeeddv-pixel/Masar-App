import 'package:flutter/material.dart';

// داخل widgets/order_status_card.dart
class OrderStatusCard extends StatelessWidget {
  final double deliveredPercent;
  final double returnedPercent;
  final double failedPercent;

  const OrderStatusCard({
    super.key,
    required this.deliveredPercent,
    required this.returnedPercent,
    required this.failedPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("حالة الطلبات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  ),
                ),
              ),
              // الليستة الجانبية
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusItem("تم التوصيل", deliveredPercent, const Color(0xFF0D47A1)),
                  _buildStatusItem("راجع", returnedPercent, Colors.orange),
                  _buildStatusItem("فشل", failedPercent, Colors.red),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, double value, Color color) {
    return Row(
      children: [
        Icon(Icons.circle, size: 10, color: color),
        const SizedBox(width: 8),
        Text("$label: ", style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text("${value.toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class MultiColorPieChartPainter extends CustomPainter {
  final double delivered, returned, failed;
  MultiColorPieChartPainter({required this.delivered, required this.returned, required this.failed});

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 15;
    Rect rect = Offset.zero & size;

    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 6.28, false, backgroundPaint);

    // 2. رسم الأجزاء الملونة فوق الرصاصي
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -1.57;

    if (delivered > 0) {
      canvas.drawArc(rect, startAngle, (delivered / 100) * 6.28, false,
          paint..color = const Color(0xFF0D47A1));
      startAngle += (delivered / 100) * 6.28;
    }

    if (returned > 0) {
      canvas.drawArc(rect, startAngle, (returned / 100) * 6.28, false,
          paint..color = Colors.orange);
      startAngle += (returned / 100) * 6.28;
    }

    if (failed > 0) {
      canvas.drawArc(rect, startAngle, (failed / 100) * 6.28, false,
          paint..color = Colors.red);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
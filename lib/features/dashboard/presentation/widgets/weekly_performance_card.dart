import 'package:flutter/material.dart';

class WeeklyPerformanceCard extends StatelessWidget {
  const WeeklyPerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('الأداء الأسبوعي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Text('طلب مكتمل', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const Text('55', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // تمثيل الرسم البياني الخطي كما في الصورة
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(painter: _ChartPainter()),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF0D47A1)..strokeWidth = 3..style = PaintingStyle.stroke;
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.2, size.height * 0.4);
    path.lineTo(size.width * 0.4, size.height * 0.6);
    path.lineTo(size.width * 0.7, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.5);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
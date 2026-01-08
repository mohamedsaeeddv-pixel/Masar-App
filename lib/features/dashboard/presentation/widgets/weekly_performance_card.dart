import 'package:flutter/material.dart';

class WeeklyPerformanceCard extends StatelessWidget {
  final int weeklyTasks;

  const WeeklyPerformanceCard({super.key, required this.weeklyTasks});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("الأداء الأسبوعي",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Text("طلب مكتمل",
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 10),
          Text(
              "$weeklyTasks",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 20),

          // إضافة الرسم البياني الخطي (الـ Graph) الذي اختفى
          SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomPaint(
              painter: LineChartPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

// كود رسم الخط المتعرج الأزرق
class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF1E63EE) // نفس لون السيم العام
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    // إحداثيات تقريبية لرسم الخط المتعرج كما في الصورة
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.2, size.height * 0.3);
    path.lineTo(size.width * 0.4, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height * 0.2);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
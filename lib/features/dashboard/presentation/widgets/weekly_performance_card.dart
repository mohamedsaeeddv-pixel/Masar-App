import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class WeeklyPerformanceCard extends StatelessWidget {
  final int weeklyTasks;
  final double fontFactor; // إضافة بارامتر حجم الخط
  final bool isDarkMode;   // إضافة بارامتر الوضع الداكن

  const WeeklyPerformanceCard({
    super.key,
    required this.weeklyTasks,
    required this.fontFactor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // تغيير الخلفية حسب المود
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDarkMode
            ? []
            : [
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
          // ربط اللغة وحجم الخط للعنوان
          Text(
              "dashboard.weekly_perf".tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16 * fontFactor,
                color: isDarkMode ? Colors.white : Colors.black,
              )
          ),
          Text(
              "dashboard.status_delivered".tr(),
              style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.grey,
                  fontSize: 14 * fontFactor
              )
          ),
          const SizedBox(height: 10),
          // ربط الرقم الكبير بحجم الخط
          Text(
              "$weeklyTasks",
              style: TextStyle(
                fontSize: 32 * fontFactor,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              )
          ),
          const SizedBox(height: 20),

          // الرسم البياني الخطي
          SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomPaint(
              painter: LineChartPainter(isDarkMode: isDarkMode),
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final bool isDarkMode;
  LineChartPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
    // اختيار لون أزهى في الدارك مود (Cyan/LightBlue)
      ..color = isDarkMode ? const Color(0xFF42A5F5) : const Color(0xFF1E63EE)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.2, size.height * 0.3);
    path.lineTo(size.width * 0.4, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height * 0.2);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.5);

    // إضافة ظل خفيف تحت الخط في الدارك مود ليعطي تأثير "Neon"
    if (isDarkMode) {
      canvas.drawPath(path, Paint()
        ..color = const Color(0xFF42A5F5).withOpacity(0.3)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
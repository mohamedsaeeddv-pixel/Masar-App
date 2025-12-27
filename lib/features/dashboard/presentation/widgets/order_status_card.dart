import 'package:flutter/material.dart';

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('حالة الطلبات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. الدائرة (يسار بالنسبة للنص العربي)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildLegend('تم التوصيل', '75%', const Color(0xFF2196F3)),
                  _buildLegend('راجع', '15%', Colors.orange),
                  _buildLegend('فشل', '10%', Colors.redAccent),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 110,
                    width: 110,
                    child: CircularProgressIndicator(
                      value: 1.0, // دايرة كاملة
                      strokeWidth: 18,
                      color: Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                  SizedBox(
                    height: 110,
                    width: 110,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 18,
                      color: const Color(0xFF0D47A1), // الأزرق الغامق
                    ),
                  ),
                  Transform.rotate(
                    angle: (2 * 3.14159) * 0.75, // لف البداية لتبدأ من نهاية الـ 75%
                    child: SizedBox(
                      height: 110,
                      width: 110,
                      child: CircularProgressIndicator(
                        value: 0.15,
                        strokeWidth: 18,
                        color: Colors.orange, // البرتقالي
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: (2 * 3.14159) * 0.90, // لف البداية لتبدأ من نهاية الـ 90%
                    child: SizedBox(
                      height: 110,
                      width: 110,
                      child: CircularProgressIndicator(
                        value: 0.10,
                        strokeWidth: 18,
                        color: Colors.redAccent, // الأحمر
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, String val, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 10),
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        ],
      ),
    );
  }
}
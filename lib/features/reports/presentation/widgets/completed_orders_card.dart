import 'package:flutter/material.dart';

class CompletedOrdersCard extends StatelessWidget {
  final int completed;
  final int total;

  const CompletedOrdersCard({
    super.key,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    double progress = total > 0 ? (completed / total) : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
          const Text(
            'الطلبات المكتملة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '5% ↗',
                style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '/$total',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade400, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$completed',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // شريط التقدم (اللون الأزرق الداكن)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade100,
              color: const Color(0xFF0D47A1),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'متبقي ${total - completed} طلبات للوصول للوجهة',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.circle, size: 8, color: Colors.blue),
            ],
          ),
        ],
      ),
    );
  }
}
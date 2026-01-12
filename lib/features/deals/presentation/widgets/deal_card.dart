import 'package:flutter/material.dart';
import '../../data/models/deal_model.dart';

class DealCard extends StatelessWidget {
  final DealModel deal;
  const DealCard({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    // 1. تحديد الألوان بناءً على الحالة الموحدة بالعربي
    Color statusColor;
    if (deal.status == "تمت") {
      statusColor = const Color(0xFF4CAF50); // أخضر
    } else if (deal.status == "فشل") {
      statusColor = const Color(0xFFE53935); // أحمر
    } else {
      statusColor = const Color(0xFFFFB300); // برتقالي قيد الانتظار
    }

    bool isPending = deal.status == 'قيد الانتظار';

    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // تلوين خلفية الكارت كله بلون الحالة بدرجة خفيفة جداً
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        // إضافة إطار (Border) بنفس لون الحالة عشان الكارت يحدد
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // الـ Badge هنا ممكن نخليه بلون الحالة الصريح
              _buildBadge(deal.status, statusColor),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            "رقم العميل: ${deal.customerId}",
            style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),

          if (!isPending) ...[
            Row(
              children: [
                const Text("المبلغ: ", style: TextStyle(fontSize: 14)),
                Text(
                  deal.amount,
                  style: const TextStyle(
                    color: Color(0xFF1E63EE), // الأزرق للمبالغ يفضل كما هو للوضوح
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text("اسم العميل: ${deal.customerName}", style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: statusColor), // الأيقونة تأخذ لون الحالة
                const SizedBox(width: 4),
                Text(deal.location, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ] else ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "التفاصيل متاحة بعد إتمام الصفقة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color, // لون صلب للـ Badge
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
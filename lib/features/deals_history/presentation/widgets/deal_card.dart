import 'package:flutter/material.dart';
import '../../data/models/deal_model.dart';

class DealCard extends StatelessWidget {
  final DealModel deal;
  const DealCard({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    bool isPending = deal.status == 'قيد الانتظار';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge(deal.status),
              Text(deal.dealId, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text("رقم العميل: ${deal.customerId}"),
          if (!isPending) ...[
            Text("المبلغ: ${deal.amount}", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            Text("اسم العميل: ${deal.customerName}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text(deal.location), const Icon(Icons.location_on, size: 14, color: Colors.grey)],
            ),
          ] else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: const Text("التفاصيل متاحة بعد إتمام الصفقة", textAlign: TextAlign.center, style: TextStyle(color: Colors.orange, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String status) {
    Color color = status == "تم التوصيل" ? Colors.green : (status == "فشل" ? Colors.red : Colors.orange);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
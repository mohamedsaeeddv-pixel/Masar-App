import 'package:flutter/material.dart';
import '../widgets/summary_card.dart';
import '../widgets/weekly_performance_card.dart';
import '../widgets/order_status_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1), //
        title: const Text('لوحة التحكم', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('مرحباً، محمد', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Row(
              children: [
                SummaryCard(title: 'الطلبات المستلمة', value: '12', percent: '5%+', icon: Icons.email_outlined, iconColor: Colors.blue),
                SizedBox(width: 12),
                SummaryCard(title: 'تم التوصيل', value: '9', percent: '2%+', icon: Icons.check_circle_outline, iconColor: Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            const WeeklyPerformanceCard(),
            const SizedBox(height: 16),
            const OrderStatusCard(),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/dashboard_cubit.dart';
import '../manager/dashboard_state.dart';
import '../widgets/summary_card.dart';
import '../widgets/weekly_performance_card.dart';
import '../widgets/order_status_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<DashboardCubit>().fetchDashboardData();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1E63EE),
        elevation: 0,
        title: const Text('لوحة التحكم', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardLoaded) {
            final data = state.data;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'مرحباً، ${data.userName}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      // عرض إجمالي الطلبات المستلمة
                      Expanded(
                        child: SummaryCard(
                            title: 'الطلبات المستلمة',
                            value: '${data.receivedOrders}',
                            percent: '5%+',
                            icon: Icons.email_outlined,
                            iconColor: Colors.blue
                        ),
                      ),
                      const SizedBox(width: 12),
                      // عرض الطلبات المكتملة (status == completed)
                      Expanded(
                        child: SummaryCard(
                            title: 'تم التوصيل',
                            value: '${data.deliveredOrders}',
                            percent: '2%+',
                            icon: Icons.check_circle_outline,
                            iconColor: Colors.green
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // تم إزالة const وإضافة المتطلب weeklyTasks
                  WeeklyPerformanceCard(weeklyTasks: data.weeklyCompletedTasks),

                  const SizedBox(height: 16),

                  OrderStatusCard(
                    deliveredPercent: data.deliveredPercent, // ربط النسبة الحقيقية
                    returnedPercent: data.returnedPercent,   // ربط النسبة الحقيقية
                    failedPercent: data.failedPercent,       // ربط النسبة الحقيقية
                  ),

                  const SizedBox(height: 70),
                ],
              ),
            );
          } else if (state is DashboardError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
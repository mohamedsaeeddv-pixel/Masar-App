import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/reports_repo_impl.dart';
import '../manager/reports_cubit.dart';
import '../manager/reports_state.dart';
import '../widgets/goal_progress_card.dart';
import '../widgets/period_selector.dart';
import '../widgets/stat_small_card.dart';
import '../widgets/completed_orders_card.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // تأكد إن ReportsRepoImpl بياخد المعاملات الصح لو فيه Dependency Injection
      create: (context) => ReportsCubit(ReportsRepoImpl())..fetchReports('يومي'),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F8),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D47A1),
          title: const Text('التقارير',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        floatingActionButton: Stack(
          alignment: Alignment.topRight,
          children: [
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: const Color(0xFF0D47A1),
              child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: const Text('1',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: BlocBuilder<ReportsCubit, ReportsState>(
          builder: (context, state) {
            if (state is ReportsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReportsSuccess) {
              final data = state.reportsModel;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('أهلاً محمد، هذا هو أداؤك اليوم 👋',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    PeriodSelector(
                      selectedPeriod: data.reportPeriod,
                      onSelect: (p) => context.read<ReportsCubit>().fetchReports(p),
                    ),
                    const SizedBox(height: 20),
                    // 1. الكارت الأزرق (الهدف)
                    GoalProgressCard(
                      completed: data.completedOrders,
                      // تعديل: استخدمنا totalOrdersGoal عشان ده اللي في الموديل
                      total: data.totalOrdersGoal,
                      sales: data.salesAmount,
                      salesGoal: data.totalSalesGoal,
                      period: data.reportPeriod,
                    ),
                    const SizedBox(height: 20),
                    const Text('الإنجاز: اليومي',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 8),
                    // 2. الكارت (الطلبات المكتملة)
                    CompletedOrdersCard(
                      completed: data.completedOrders,
                      total: data.totalOrdersGoal, // تعديل هنا كمان
                    ),
                    const SizedBox(height: 16),
                    // 3. الكروت الصغيرة
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded( // ضفت Expanded عشان الكروت متضربش Pixel Overflow
                          child: StatSmallCard(
                              title: 'المبالغ المحصلة',
                              value: '${data.salesAmount.toInt()} جنيه',
                              percent: '10%+',
                              icon: Icons.account_balance_wallet_outlined
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatSmallCard(
                              title: 'المسافة',
                              value: '${data.distanceKm.toInt()} كم',
                              percent: '5%+',
                              icon: Icons.directions_car_filled_outlined
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            // تعديل: غيرنا لـ ReportsFailure واستخدمنا errorMessage وش نظافة
            if (state is ReportsFailure) {
              return Center(child: Text(state.errMessage, style: const TextStyle(color: Colors.red)));
            }

            return const Center(child: Text('جاري تهيئة البيانات...'));
          },
        ),
      ),
    );
  }
}
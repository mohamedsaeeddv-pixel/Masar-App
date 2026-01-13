import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart'; // للترجمة
import 'package:masar_app/features/settings/presentation/manager/settings_cubit.dart';
import 'package:masar_app/features/settings/presentation/manager/settings_state.dart';
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

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        double fontFactor = 1.0;
        if (settingsState is SettingsDataState) {
          if (settingsState.settings.fontSize == 'كبير') fontFactor = 1.2;
          if (settingsState.settings.fontSize == 'صغير') fontFactor = 0.8;
        }

        return Scaffold(
          backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF2F5F9),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Color(0xFF1E63EE),
            elevation: 0,
            title: Text(
              'dashboard.title'.tr(), // ربط اللغة (الترجمة)
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20 * fontFactor, // ربط حجم الخط
              ),
            ),
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
                        'dashboard.welcome'.tr(args: [data.userName]),
                        style: TextStyle(
                          fontSize: 22 * fontFactor,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: SummaryCard(
                              title: 'dashboard.received_orders'.tr(),
                              value: '${data.receivedOrders}',
                              percent: '5%+',
                              icon: Icons.email_outlined,
                              iconColor: Colors.blue,
                              fontFactor: fontFactor,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SummaryCard(
                              title: 'dashboard.delivered'.tr(), // ربط اللغة
                              value: '${data.deliveredOrders}',
                              percent: '2%+',
                              icon: Icons.check_circle_outline,
                              iconColor: Colors.green,
                              fontFactor: fontFactor,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // تمرير الإعدادات للـ Weekly Card
                      WeeklyPerformanceCard(
                        weeklyTasks: data.weeklyCompletedTasks,
                        fontFactor: fontFactor,
                        isDarkMode: isDarkMode,
                      ),

                      const SizedBox(height: 16),

                      // تمرير الإعدادات للـ Order Status Card (الرسوم البيانية)
                      OrderStatusCard(
                        deliveredPercent: data.deliveredPercent,
                        returnedPercent: data.returnedPercent,
                        failedPercent: data.failedPercent,
                        fontFactor: fontFactor,
                        isDarkMode: isDarkMode,
                      ),

                      const SizedBox(height: 70),
                    ],
                  ),
                );
              } else if (state is DashboardError) {
                return Center(child: Text(state.message.tr())); // ترجمة رسالة الخطأ لو موجودة
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
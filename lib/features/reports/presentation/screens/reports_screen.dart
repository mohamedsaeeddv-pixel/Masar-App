import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masar_app/features/settings/presentation/manager/settings_cubit.dart';
import 'package:masar_app/features/settings/presentation/manager/settings_state.dart';
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
      create: (context) => ReportsCubit(ReportsRepoImpl())..fetchReports('يومي'),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;

          double fontFactor = 1.0;
          if (settingsState is SettingsDataState) {
            if (settingsState.settings.fontSize == 'كبير') fontFactor = 1.2;
            if (settingsState.settings.fontSize == 'صغير') fontFactor = 0.8;
          }

          return Scaffold(
            backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F6F8),
            appBar: AppBar(
              backgroundColor:const Color(0xFF0D47A1),
              title: Text(
                  'reports.title'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20 * fontFactor,
                  )
              ),
              centerTitle: true,
              elevation: 0,
            ),
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
                      children: [
                        Text(
                            'reports.welcome'.tr(args: [data.userName]),
                            style: TextStyle(
                              fontSize: 16 * fontFactor,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            )
                        ),
                        const SizedBox(height: 16),
                        PeriodSelector(
                          selectedPeriod: data.reportPeriod,
                          onSelect: (p) {
                            String originalValue = 'يومي';
                            if (p.contains('أسبوع') || p == 'reports.weekly'.tr()) originalValue = 'أسبوعي';
                            if (p.contains('شهر') || p == 'reports.monthly'.tr()) originalValue = 'شهري';

                            context.read<ReportsCubit>().fetchReports(originalValue);
                          },
                          fontFactor: fontFactor,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 20),

                        // الكروت دي جواها AnimatedSwitcher للأرقام بس، فالداتا هتتحدث بنعومة فوراً
                        GoalProgressCard(
                          completed: data.completedOrders,
                          total: data.totalOrdersGoal,
                          sales: data.salesAmount,
                          salesGoal: data.totalSalesGoal,
                          fontFactor: fontFactor,
                          isDarkMode: isDarkMode,
                          // ميثود التحويل اللي عملناها في الرد اللي فات
                          period: (data.reportPeriod == 'أسبوعي'
                              ? 'reports.periods.weekly'.tr()
                              : data.reportPeriod == 'شهري'
                              ? 'reports.periods.monthly'.tr()
                              : 'reports.periods.daily'.tr()),
                        ),
                        const SizedBox(height: 20),
                        CompletedOrdersCard(
                          completed: data.completedOrders,
                          total: data.totalOrdersGoal,
                          fontFactor: fontFactor,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: StatSmallCard(
                                title: 'reports.collected_amount'.tr(),
                                value: '${data.salesAmount.toInt()} ${'reports.currency'.tr()}',
                                percent: '10%+',
                                icon: Icons.account_balance_wallet_outlined,
                                fontFactor: fontFactor,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StatSmallCard(
                                title: 'reports.distance'.tr(),
                                value: '${data.distanceKm.toInt()} ${'reports.unit_km'.tr()}',
                                percent: '5%+',
                                icon: Icons.directions_car_filled_outlined,
                                fontFactor: fontFactor,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                if (state is ReportsFailure) {
                  return Center(child: Text(state.errMessage.tr(), style: const TextStyle(color: Colors.red)));
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
  // Widget _buildContentBasedOnState(BuildContext context, ReportsState state, bool isDarkMode, double fontFactor) {

  //   if (state is ReportsSuccess) {
  //     final data = state.reportsModel;
  //     return SingleChildScrollView(
  //       key: ValueKey('success_${data.reportPeriod}'),
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         children: [
  //           Text(
  //               'reports.welcome'.tr(args: [data.userName]),
  //               style: TextStyle(
  //                 fontSize: 16 * fontFactor,
  //                 fontWeight: FontWeight.bold,
  //                 color: isDarkMode ? Colors.white : Colors.black,
  //               )
  //           ),
  //           const SizedBox(height: 16),
  //           PeriodSelector(
  //             selectedPeriod: data.reportPeriod,
  //             onSelect: (p) => context.read<ReportsCubit>().fetchReports(p),
  //             fontFactor: fontFactor,
  //             isDarkMode: isDarkMode,
  //           ),
  //           const SizedBox(height: 20),

  //           // باقي الـ Widgets (GoalProgressCard, CompletedOrdersCard, إلخ...)
  //           GoalProgressCard(
  //             completed: data.completedOrders,
  //             total: data.totalOrdersGoal,
  //             sales: data.salesAmount,
  //             salesGoal: data.totalSalesGoal,
  //             period: data.reportPeriod,
  //             fontFactor: fontFactor,
  //             isDarkMode: isDarkMode,
  //           ),
  //           const SizedBox(height: 20),
  //           CompletedOrdersCard(
  //             completed: data.completedOrders,
  //             total: data.totalOrdersGoal,
  //             fontFactor: fontFactor,
  //             isDarkMode: isDarkMode,
  //           ),
  //           const SizedBox(height: 16),
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: StatSmallCard(
  //                   title: 'reports.collected_amount'.tr(),
  //                   value: '${data.salesAmount.toInt()} ${'reports.currency'.tr()}',
  //                   percent: '10%+',
  //                   icon: Icons.account_balance_wallet_outlined,
  //                   fontFactor: fontFactor,
  //                   isDarkMode: isDarkMode,
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: StatSmallCard(
  //                   title: 'reports.distance'.tr(),
  //                   value: '${data.distanceKm.toInt()} ${'reports.unit_km'.tr()}',
  //                   percent: '5%+',
  //                   icon: Icons.directions_car_filled_outlined,
  //                   fontFactor: fontFactor,
  //                   isDarkMode: isDarkMode,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   }

  //   if (state is ReportsFailure) {
  //     return Center(
  //       key: const ValueKey('failure_state'),
  //       child: Text(state.errMessage.tr(), style: const TextStyle(color: Colors.red)),
  //     );
  //   }
  //   return const SizedBox.shrink();
  // }
}
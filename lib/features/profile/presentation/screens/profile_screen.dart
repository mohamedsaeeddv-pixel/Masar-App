import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

// --- Imports (Managers & Repos) ---
import 'package:masar_app/features/login/presentation/manager/auth_cubit.dart';
import 'package:masar_app/features/profile/data/repos/profile_repo_impl.dart';
import 'package:masar_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:masar_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:masar_app/features/dashboard/data/repos/dashboard_repo.dart';
import 'package:masar_app/features/deals/presentation/manager/deals_cubit.dart';
import 'package:masar_app/features/deals/data/repos/deals_repo_impl.dart';

// --- Imports (Screens & Widgets) ---
import 'package:masar_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:masar_app/features/deals/presentation/screens/deals_screen.dart';
import 'package:masar_app/features/reports/presentation/screens/reports_screen.dart';
import '../widgets/info_tile.dart';
import '../widgets/menu_item.dart';
import '../widgets/profile_header.dart';
import '../widgets/stats_card.dart';

// --- Core ---
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../../../routes/app_router.dart'; // مهم عشان الـ authNotifier
import '../../../../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // يمكن جلب الـ fontFactor من الـ SettingsCubit مستقبلاً، حالياً 1.0
    double fontFactor = 1.0;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => ProfileCubit(ProfileRepoImpl())..getProfileData(),
      child: Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F6F8),
        appBar: AppBar(
          backgroundColor: AppColors.bluePrimaryDark,
          title: Text(
            'profile.title'.tr(),
            style: AppTextStyles.title20Bold.copyWith(fontSize: 20 * fontFactor),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) return const Center(child: CircularProgressIndicator());

            if (state is ProfileSuccess) {
              final user = state.user;
              final width = MediaQuery.of(context).size.width;
              final height = MediaQuery.of(context).size.height;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(width * 0.04),
                child: Column(
                  children: [
                    ProfileHeader(
                      name: context.locale.languageCode == 'ar' ? user.nameAr : user.nameEn,
                      fontFactor: fontFactor,
                    ),
                    SizedBox(height: height * 0.02),
                    // Row(
                    //   children: [
                    //     Expanded(child: StatsCard(value: user.workingHours, label: 'profile.work_hours'.tr(), fontFactor: fontFactor)),
                    //     const SizedBox(width: 12),
                    //     Expanded(child: StatsCard(value: user.completedTasks, label: 'profile.completed_tasks'.tr(), fontFactor: fontFactor)),
                    //   ],
                    // ),
                    SizedBox(height: height * 0.015),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('deals.title'.tr(),
                          style: AppTextStyles.body16Bold.copyWith(
                              color: isDarkMode ? Colors.white : AppColors.textPrimaryDark,
                              fontSize: 16 * fontFactor
                          )),
                    ),
                    SizedBox(height: height * 0.015),

                    // --- روابط سريعة ---
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          MenuItem(
                            title: 'dashboard.title'.tr(),
                            icon: Icons.dashboard_outlined,
                            iconBg: const Color(0xFFE3F2FD),
                            iconColor: AppColors.chartBlue,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => DashboardCubit(DashboardRepo()),
                                    child: const DashboardScreen(),
                                  ),
                                ),
                              );
                            },
                          ),
                          MenuItem(
                            title: 'reports.title'.tr(),
                            icon: Icons.description_outlined,
                            iconBg: const Color(0xFFE8F5E9),
                            iconColor: AppColors.chartCyan,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ReportsScreen()),
                              );
                            },
                          ),
                          MenuItem(
                            title: 'deals.title'.tr(),
                            icon: Icons.shopping_bag_outlined,
                            iconBg: const Color(0xFFFFF3E0),
                            iconColor: AppColors.chartAmber,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => DealsCubit(DealsRepoImpl())..getDeals(),
                                    child: const DealsScreen(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: height * 0.025),
                    _buildPersonalInfoSection(user, fontFactor, isDarkMode),
                    SizedBox(height: height * 0.04),
                    _buildLogoutButton(context, fontFactor),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(dynamic user, double fontFactor, bool isDarkMode) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.person_outline, color: AppColors.chartBlue),
            const SizedBox(width: 12),
            Text('profile.personal_info'.tr(),
                style: AppTextStyles.body16Bold.copyWith(
                    color: isDarkMode ? Colors.white : AppColors.textPrimaryDark,
                    fontSize: 16 * fontFactor
                )),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
              color: isDarkMode ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(12)
          ),
          child: Column(
            children: [
              InfoTile(title: 'login.email_label'.tr(), value: user.email, icon: Icons.email_outlined, fontFactor: fontFactor),
              InfoTile(title: 'add_client.phone'.tr(), value: user.phone, icon: Icons.phone_outlined, fontFactor: fontFactor),
              InfoTile(title: 'profile.id_num'.tr(), value: user.role, icon: Icons.work_outline, fontFactor: fontFactor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, double fontFactor) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: Colors.red),
            const SizedBox(width: 12),
            Text('profile.logout'.tr(),
                style: AppTextStyles.body16Bold.copyWith(color: Colors.red, fontSize: 16 * fontFactor)),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('profile.logout'.tr(), textAlign: TextAlign.center),
        content: Text('common.confirm'.tr(), textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('common.back'.tr())),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              // 1. إغلاق الديالوج
              Navigator.pop(dialogContext);

              // 2. تسجيل الخروج من الـ Cubit (لتغيير الحالة في التطبيق بالكامل)
              await context.read<AuthCubit>().logout();

              // 3. تنبيه الراوتر لإعادة فحص الحالة فوراً
              AppRouter.authNotifier.add(null);

              // 4. التوجه لصفحة اللوجن ومسح الـ stack
              if (context.mounted) {
                context.goNamed('login');
              }
            },
            child: Text('profile.logout'.tr(), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
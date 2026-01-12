// features/profile/presentation/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masar_app/features/login/data/repos/auth_repo_impl.dart';
import '../../../dashboard/data/repos/dashboard_repo.dart';
import '../../../dashboard/presentation/manager/dashboard_cubit.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../deals/data/repos/deals_repo_impl.dart';
import '../../../deals/presentation/manager/deals_cubit.dart';
import '../../../deals/presentation/screens/deals_screen.dart';
import '../../../reports/presentation/screens/reports_screen.dart';
import '../../data/repos/profile_repo_impl.dart';
import '../manager/profile_cubit.dart';
import '../widgets/info_tile.dart';
import '../widgets/menu_item.dart';
import '../widgets/profile_header.dart';
import '../widgets/stats_card.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(ProfileRepoImpl())..getProfileData(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F8),
        appBar: AppBar(
          backgroundColor: AppColors.bluePrimaryDark,
          title: const Text(
            'الملف الشخصي',
            style: AppTextStyles.title20Bold,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileSuccess) {
              final user = state.user;
              final width = MediaQuery.of(context).size.width;
              final height = MediaQuery.of(context).size.height;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(width * 0.04),
                child: Column(
                  children: [
                    ProfileHeader(name: user.nameAr), // استخدام nameAr من الـ Snapshot
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        Expanded(child: StatsCard(value: user.workingHours, label: 'ساعات العمل')),
                        const SizedBox(width: 12),
                        Expanded(child: StatsCard(value: user.completedTasks, label: 'المهام المكتملة')),
                      ],
                    ),
                    SizedBox(height: height * 0.025),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('روابط سريعة',
                          style: AppTextStyles.body16Bold.copyWith(color: AppColors.textPrimaryDark)),
                    ),
                    SizedBox(height: height * 0.015),

                    // --- الروابط السريعة ---
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
// داخل MenuItem الخاص بلوحة التحكم في profile_screen.dart
                          MenuItem(
                            title: 'لوحة التحكم',
                            icon: Icons.dashboard_outlined,
                            iconBg: const Color(0xFFE3F2FD),
                            iconColor: AppColors.chartBlue,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    // هنا بنوفر الـ Cubit والـ Repo للشاشة
                                    create: (context) => DashboardCubit(DashboardRepo()),
                                    child: const DashboardScreen(),
                                  ),
                                ),
                              );
                            },
                          ),
                          MenuItem(
                            title: 'التقارير',
                            icon: Icons.description_outlined,
                            iconBg: const Color(0xFFE8F5E9),
                            iconColor: AppColors.chartCyan,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ReportsScreen(),
                                ),
                              );
                            },
                          ),
                          MenuItem(
                            title: 'الصفقات',
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
                    _buildPersonalInfoSection(user), // تمرير بيانات الـ Model
                    SizedBox(height: height * 0.04),
                    _buildLogoutButton(context, height),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              );
            }

            if (state is ProfileError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  // ميثود المعلومات الشخصية - بدون عرض كود المستخدم (UserId)
  Widget _buildPersonalInfoSection(dynamic user) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            const Icon(Icons.person_outline, color: AppColors.chartBlue),
            const SizedBox(width: 12),
            Text('المعلومات الشخصية',
                style: AppTextStyles.body16Bold.copyWith(color: AppColors.textPrimaryDark)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              InfoTile(title: 'البريد الإلكتروني', value: user.email, icon: Icons.email_outlined),
              InfoTile(title: 'رقم التليفون', value: user.phone, icon: Icons.phone_outlined),
              InfoTile(title: 'الوظيفة', value: user.role, icon: Icons.work_outline),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, double height) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: [
            const Icon(Icons.logout_rounded, color: Colors.red),
            const SizedBox(width: 12),
            Text('تسجيل الخروج', style: AppTextStyles.body16Bold.copyWith(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تسجيل الخروج', textAlign: TextAlign.right),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟', textAlign: TextAlign.right),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await AuthRepoImpl().logout();
              if (context.mounted) context.goNamed(AppRoutes.login);
            },
            child: const Text('خروج', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../widgets/info_tile.dart';
import '../../widgets/menu_item.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/stats_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: AppColors.bluePrimaryDark,
        title: Text(
          'الملف الشخصي',
          style: AppTextStyles.title20Bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          children: [
            const ProfileHeader(),

            SizedBox(height: height * 0.02),

            Row(
              children: const [
                Expanded(
                  child: StatsCard(
                    value: '124',
                    label: 'ساعات العمل',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    value: '1,240',
                    label: 'المهام المكتمله',
                  ),
                ),
              ],
            ),

            SizedBox(height: height * 0.025),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'روابط سريعة',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            SizedBox(height: height * 0.015),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  MenuItem(
                    title: 'لوحة التحكم',
                    icon: Icons.dashboard_outlined,
                    iconBg: const Color(0xFFE3F2FD),
                    iconColor: AppColors.chartBlue,
                    onTap: () {},
                  ),
                  MenuItem(
                    title: 'التقارير',
                    icon: Icons.description_outlined,
                    iconBg: const Color(0xFFE8F5E9),
                    iconColor: AppColors.chartCyan,
                    onTap: () {},
                  ),
                  MenuItem(
                    title: 'الصفقات',
                    icon: Icons.shopping_bag_outlined,
                    iconBg: const Color(0xFFFFF3E0),
                    iconColor: AppColors.chartAmber,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.025),

            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: AppColors.chartBlue,
                ),
                SizedBox(width: width * 0.04),
                Text(
                  'المعلومات الشخصية',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),

            SizedBox(height: height * 0.015),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  InfoTile(
                    title: 'البريد الإلكتروني',
                    value: 'mohamed.ahmed@masar.com',
                    icon: Icons.email_outlined,
                  ),
                  InfoTile(
                    title: 'رقم التليفون',
                    value: '+20 101 234 5678',
                    icon: Icons.phone_outlined,
                  ),
                  InfoTile(
                    title: 'المحافظة',
                    value: 'القاهرة',
                    icon: Icons.location_on_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


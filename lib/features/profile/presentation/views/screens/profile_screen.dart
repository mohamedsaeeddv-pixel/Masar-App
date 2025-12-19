import 'package:flutter/material.dart';

import '../../widgets/info_tile.dart';
import '../../widgets/menu_item.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/stats_card.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text('الملف الشخصي',
          style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ProfileHeader(),

            const SizedBox(height: 16),

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

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'روابط سريعة',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children:  [
                  MenuItem(
                    title: 'لوحة التحكم',
                    icon: Icons.dashboard_outlined,
                    iconBg: Color(0xFFE3F2FD),
                    iconColor: Color(0xFF1565C0),
                  ),
                  MenuItem(
                    title: 'التقارير',
                    icon: Icons.description_outlined,
                    iconBg: Color(0xFFE8F5E9),
                    iconColor: Color(0xFF2E7D32),
                  ),
                  MenuItem(
                    title: 'الصفقات',
                    icon: Icons.shopping_bag_outlined,
                    iconBg: Color(0xFFFFF3E0),
                    iconColor: Color(0xFFEF6C00),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Color(0xFF1565C0),
                ),
                const SizedBox(width: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'المعلومات الشخصية',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child:  Column(
                children: [
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

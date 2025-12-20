import 'package:flutter/material.dart';
import '../../widgets/info_row.dart';
import '../../widgets/option_button.dart';
import '../../widgets/section_card.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text('الإعدادات'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 Font Size
            SectionCard(
              title: 'حجم الخط',
              icon: Icons.text_fields,
              child: Row(
                children: const [
                  Expanded(child: OptionButton(label: 'كبير', sub: 'Aa')),
                  SizedBox(width: 8),
                  Expanded(
                    child: OptionButton(
                      label: 'متوسط',
                      sub: 'Aa',
                      selected: true,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(child: OptionButton(label: 'صغير', sub: 'Aa')),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 Theme
            SectionCard(
              title: 'المظهر',
              icon: Icons.brightness_6_outlined,
              child: Row(
                children: const [
                  Expanded(
                    child: OptionButton(
                      label: 'داكن',
                      icon: Icons.nightlight_round,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OptionButton(
                      label: 'فاتح',
                      icon: Icons.wb_sunny_outlined,
                      selected: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 Language
            SectionCard(
              title: 'اللغة',
              icon: Icons.language,
              child: Row(
                children: const [
                  Expanded(child: OptionButton(label: 'English', flag: '🇬🇧')),
                  SizedBox(width: 8),
                  Expanded(
                    child: OptionButton(
                      label: 'العربية',
                      flag: '🇪🇬',
                      selected: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 About App
            SectionCard(
              title: 'معلومات عن التطبيق',
              icon: Icons.info_outline,
              child: Column(
                children:  [
                  InfoRow(title: 'اسم التطبيق', value: 'مسار'),
                  InfoRow(title: 'الإصدار', value: '1.0.0'),
                  InfoRow(title: 'تاريخ الإصدار', value: '2024-01-15'),
                  InfoRow(
                    title: 'الوصف',
                    value:
                    'تطبيق مسار لإدارة وتتبع مهام التوصيل والمندوبين بكفاءة عالية',
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'support@masar.com',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 Footer
            Column(
              children: const [
                Text('Masar Team', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  '© 2024 جميع الحقوق محفوظة',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../widgets/option_button.dart';
import '../../widgets/section_card.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int selectedFontSize = 1;
  int selectedTheme = 0;
  int selectedLanguage = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: AppColors.bluePrimaryDark,
        title: Text(
          'الإعدادات',
          style: AppTextStyles.title20Bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          children: [
            SectionCard(
              title: 'حجم الخط',
              icon: Icons.text_fields,
              child: Row(
                children: [
                  Expanded(
                    child: OptionButton(
                      label: 'صغير',
                      sub: 'Aa',
                      selected: selectedFontSize == 0,
                      onTap: () {
                        setState(() => selectedFontSize = 0);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OptionButton(
                      label: 'متوسط',
                      sub: 'Aa',
                      selected: selectedFontSize == 1,
                      onTap: () {
                        setState(() => selectedFontSize = 1);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OptionButton(
                      label: 'كبير',
                      sub: 'Aa',
                      selected: selectedFontSize == 2,
                      onTap: () {
                        setState(() => selectedFontSize = 2);
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.02),


            SectionCard(
              title: 'المظهر',
              icon: Icons.brightness_6_outlined,
              child: Row(
                children: [
                  Expanded(
                    child: OptionButton(
                      label: 'فاتح',
                      icon: Icons.wb_sunny_outlined,
                      selected: selectedTheme == 0,
                      onTap: () {
                        setState(() => selectedTheme = 0);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OptionButton(
                      label: 'داكن',
                      icon: Icons.nightlight_round,
                      selected: selectedTheme == 1,
                      onTap: () {
                        setState(() => selectedTheme = 1);
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.02),


            SectionCard(
              title: 'اللغة',
              icon: Icons.language,
              child: Row(
                children: [
                  Expanded(
                    child: OptionButton(
                      label: 'العربية',
                      flag: '🇪🇬',
                      selected: selectedLanguage == 0,
                      onTap: () {
                        setState(() => selectedLanguage = 0);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OptionButton(
                      label: 'English',
                      flag: '🇬🇧',
                      selected: selectedLanguage == 1,
                      onTap: () {
                        setState(() => selectedLanguage = 1);
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.03),


            Column(
              children: const [
                Text(
                  'تم التطوير بواسطة',
                  style: TextStyle(
                      color:AppColors.textMutedGray,
                      fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'Masar Team',
                  style:AppTextStyles.body14Regular,
                ),
                SizedBox(height: 4),
                Text(
                  '© 2024 جميع الحقوق محفوظة',
                  style: TextStyle(color: AppColors.textMutedGray, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


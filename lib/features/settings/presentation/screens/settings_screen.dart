import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../data/models/settings_model.dart';
import '../../data/repos/settings_repo_impl.dart';
import '../manager/settings_cubit.dart';
import '../manager/settings_state.dart';
import '../widgets/app_info_item.dart';
import '../widgets/option_card.dart';
import '../widgets/settings_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(SettingsRepoImpl())..loadSettings(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.bluePrimaryDark,
          title: const Text('الإعدادات', style: AppTextStyles.title20Bold),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            // 1. معالجة حالة التحميل
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.bluePrimaryDark));
            }

            // 2. معالجة حالة عرض البيانات (سواء تحميل لأول مرة أو تحديث)
            if (state is SettingsLoaded || state is SettingsUpdated) {

              // تعريف متغير settings بناءً على الـ state الحالية
              final settings = (state is SettingsLoaded)
                  ? state.settings
                  : (state as SettingsUpdated).settings;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // قسم حجم الخط
                    SettingsSection(
                      title: 'حجم الخط',
                      icon: Icons.format_size,
                      child: Row(
                        children: [
                          _buildFontSizeOption(context, settings, 'كبير'),
                          const SizedBox(width: 8),
                          _buildFontSizeOption(context, settings, 'متوسط'),
                          const SizedBox(width: 8),
                          _buildFontSizeOption(context, settings, 'صغير'),
                        ],
                      ),
                    ),

                    // قسم المظهر
                    SettingsSection(
                      title: 'المظهر',
                      icon: Icons.light_mode_outlined,
                      child: Row(
                        children: [
                          _buildThemeOption(context, settings, 'داكن', Icons.nightlight_round),
                          const SizedBox(width: 8),
                          _buildThemeOption(context, settings, 'فاتح', Icons.wb_sunny_outlined),
                        ],
                      ),
                    ),

                    // قسم اللغة
                    SettingsSection(
                      title: 'اللغة',
                      icon: Icons.language,
                      child: Row(
                        children: [
                          _buildLanguageOption(context, settings, 'English 🇺🇸', 'en'),
                          const SizedBox(width: 8),
                          _buildLanguageOption(context, settings, 'العربية 🇪🇬', 'ar'),
                        ],
                      ),
                    ),

                    // قسم معلومات التطبيق
                    const SettingsSection(
                      title: 'معلومات عن التطبيق',
                      icon: Icons.info_outline,
                      child: Column(
                        children: [
                          AppInfoItem(label: 'اسم التطبيق', value: 'مسار'),
                          AppInfoItem(label: 'الإصدار', value: '1.0.0'),
                          AppInfoItem(label: 'تاريخ الإصدار', value: '2024-01-15'),
                          AppInfoItem(label: 'الدعم الفني', value: 'support@masar.com'),
                        ],
                      ),
                    ),
                    SettingsSection(
                      title: 'الوصف',
                      icon: Icons.description_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // المحاذاة لليمين في العربي
                        children: [
                          Text(
                            'تطبيق مسار هو رفيقك الذكي لإدارة رحلاتك ومهامك اليومية بكل سهولة. نهدف لتوفير تجربة مستخدم سلسة تساعدك على تنظيم وقتك والوصول لأهدافك بأفضل وسيلة ممكنة.',
                            style: AppTextStyles.body14Regular.copyWith(
                              color: AppColors.textPrimaryDark,
                              height: 1.6, // مسافة بين السطور لراحة العين
                            ),
                            textAlign: TextAlign.justify, // توزيع النص بشكل متساوي
                          ),
                          const SizedBox(height: 12),
                          // ممكن تضيف شعار صغير أو لينك لموقعك هنا
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.star, color: AppColors.bluePrimaryDark, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'نسعى دائماً للأفضل بمساعدتكم.',
                                style: AppTextStyles.body14Regular.copyWith(color: AppColors.bluePrimaryDark),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text('تم التطوير بواسطة', style: AppTextStyles.body14Regular.copyWith(color: AppColors.textMutedGray)),
                    Text('Masar Team', style: AppTextStyles.body16Bold.copyWith(color: AppColors.bluePrimaryDark)),
                    Text('© 2025 جميع الحقوق محفوظة', style: AppTextStyles.body14Regular.copyWith(color: AppColors.textMutedGray, fontSize: 10)),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }

            // حالة الخطأ أو البداية
            return const Center(child: Text('حدث خطأ أثناء تحميل الإعدادات'));
          },
        ),
      ),
    );
  }

  // --- دوال المساعدة (Helper Methods) لتقليل تكرار الكود ---

  Widget _buildFontSizeOption(BuildContext context, SettingsModel settings, String value) {
    return OptionCard(
      label: value,
      subLabel: 'Aa',
      isSelected: settings.fontSize == value,
      onTap: () => context.read<SettingsCubit>().updateSettings(
        SettingsModel(fontSize: value, themeMode: settings.themeMode, language: settings.language),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, SettingsModel settings, String value, IconData icon) {
    return OptionCard(
      label: value,
      icon: icon,
      isSelected: settings.themeMode == value,
      onTap: () => context.read<SettingsCubit>().updateSettings(
        SettingsModel(fontSize: settings.fontSize, themeMode: value, language: settings.language),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, SettingsModel settings, String label, String langCode) {
    return OptionCard(
      label: label,
      isSelected: settings.language == langCode,
      onTap: () => context.read<SettingsCubit>().updateSettings(
        SettingsModel(fontSize: settings.fontSize, themeMode: settings.themeMode, language: langCode),
      ),
    );
  }
}
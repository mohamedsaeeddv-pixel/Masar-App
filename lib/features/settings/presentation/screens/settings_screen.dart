import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart'; // مهم جداً للريستارت
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../data/models/settings_model.dart';
import '../manager/settings_cubit.dart';
import '../manager/settings_state.dart';
import '../widgets/option_card.dart';
import '../widgets/settings_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // كائن لتخزين التعديلات المؤقتة قبل الضغط على "تطبيق"
  SettingsModel? tempSettings;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is SettingsDataState) {
          // إذا كانت tempSettings فارغة (أول مرة)، نأخذ القيم من الحالة الحالية
          tempSettings ??= state.settings;

          return Scaffold(
            backgroundColor: isDarkMode ? const Color(0xFF121212) : AppColors.backgroundLight,
            appBar: AppBar(
              backgroundColor: AppColors.bluePrimaryDark,
              title: Text('settings.title'.tr(), style: AppTextStyles.title20Bold.copyWith(color: Colors.white)),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // قسم حجم الخط
                  SettingsSection(
                    title: 'settings.font_size'.tr(),
                    icon: Icons.format_size,
                    child: Row(
                      children: [
                        _buildFontSizeOption(tempSettings!, 'settings.font_large'.tr(), 'كبير'),
                        const SizedBox(width: 8),
                        _buildFontSizeOption(tempSettings!, 'settings.font_medium'.tr(), 'متوسط'),
                        const SizedBox(width: 8),
                        _buildFontSizeOption(tempSettings!, 'settings.font_small'.tr(), 'صغير'),
                      ],
                    ),
                  ),

                  // قسم المظهر
                  SettingsSection(
                    title: 'settings.theme'.tr(),
                    icon: Icons.light_mode_outlined,
                    child: Row(
                      children: [
                        _buildThemeOption(tempSettings!, 'settings.theme_dark'.tr(), 'داكن', Icons.nightlight_round),
                        const SizedBox(width: 8),
                        _buildThemeOption(tempSettings!, 'settings.theme_light'.tr(), 'فاتح', Icons.wb_sunny_outlined),
                      ],
                    ),
                  ),

                  // قسم اللغة
                  SettingsSection(
                    title: 'settings.lang'.tr(),
                    icon: Icons.language,
                    child: Row(
                      children: [
                        _buildLanguageOption(tempSettings!, 'English 🇺🇸', 'en'),
                        const SizedBox(width: 8),
                        _buildLanguageOption(tempSettings!, 'العربية 🇪🇬', 'ar'),
                      ],
                    ),
                  ),

                  // باقي الأقسام (About, Description) تظل كما هي...
                ],
              ),
            ),
            // زر تطبيق الإعدادات يظهر فقط إذا حدث تغيير عن الحالة الأصلية
            bottomNavigationBar: _buildApplyButton(state.settings),
          );
        }
        return const Scaffold(body: Center(child: Text('حدث خطأ')));
      },
    );
  }

  // --- زر التطبيق (Apply) ---
  Widget? _buildApplyButton(SettingsModel originalSettings) {
    // التأكد من وجود تغيير فعلي
    bool hasChanged = tempSettings?.themeMode != originalSettings.themeMode ||
        tempSettings?.fontSize != originalSettings.fontSize ||
        tempSettings?.language != originalSettings.language;

    if (!hasChanged) return null;

    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bluePrimaryDark,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => _showRestartDialog(),
        child: Text('settings.apply'.tr(), style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  void _showRestartDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('settings.restart_title'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('settings.restart_msg'.tr()),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: AppColors.bluePrimaryDark),
          ],
        ),
      ),
    );

    // تنفيذ الحفظ والريستارت
    Future.delayed(const Duration(milliseconds: 500), () async {
      await context.read<SettingsCubit>().updateSettings(tempSettings!);
      if (mounted) Phoenix.rebirth(context);
    });
  }

  // --- تحديث الهيلبر ميثودز لتعديل الـ tempSettings فقط ---

  Widget _buildLanguageOption(SettingsModel settings, String label, String langCode) {
    return OptionCard(
      label: label,
      isSelected: settings.language == langCode,
      onTap: () => setState(() => tempSettings = settings.copyWith(language: langCode)),
    );
  }

  Widget _buildFontSizeOption(SettingsModel settings, String label, String value) {
    return OptionCard(
      label: label,
      subLabel: 'Aa',
      isSelected: settings.fontSize == value,
      onTap: () => setState(() => tempSettings = settings.copyWith(fontSize: value)),
    );
  }

  Widget _buildThemeOption(SettingsModel settings, String label, String value, IconData icon) {
    return OptionCard(
      label: label,
      icon: icon,
      isSelected: settings.themeMode == value,
      onTap: () => setState(() => tempSettings = settings.copyWith(themeMode: value)),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masar_app/features/settings/presentation/manager/settings_cubit.dart';
import 'package:masar_app/features/settings/presentation/manager/settings_state.dart';
import '../manager/deals_cubit.dart';
import '../widgets/deal_card.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        double fontFactor = 1.0;
        if (settingsState is SettingsDataState) {
          if (settingsState.settings.fontSize == 'كبير') fontFactor = 1.2;
          if (settingsState.settings.fontSize == 'صغير') fontFactor = 0.8;
        }

        // باليتة ألوان الدارك مود الجديدة
        final Color bgColor = isDarkMode ? const Color(0xFF0A0E14) : const Color(0xFFF8F9FA);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text("deals.title".tr(),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18 * fontFactor)),
            centerTitle: true,
            backgroundColor: const Color(0xFF1A56BE),
          ),
          body: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (v) => context.read<DealsCubit>().searchDeals(v),
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: "deals.search".tr(),
                    hintStyle: TextStyle(color: isDarkMode ? Colors.white38 : Colors.grey),
                    prefixIcon: Icon(Icons.search, color: isDarkMode ? const Color(0xFF4FC3F7) : Colors.grey),
                    filled: true,
                    fillColor: isDarkMode ? const Color(0xFF1C2431) : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: isDarkMode ? const BorderSide(color: Color(0xFF2D3748)) : BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterChip(context, "deals.tabs_all", "الكل", isDarkMode, fontFactor, const Color(0xFF4FC3F7)),
                    _buildFilterChip(context, "deals.tabs_done", "تمت", isDarkMode, fontFactor, const Color(0xFF81C784)),
                    _buildFilterChip(context, "deals.tabs_pending", "قيد الانتظار", isDarkMode, fontFactor, const Color(0xFFFFB74D)),
                    _buildFilterChip(context, "deals.tabs_failed", "فشل", isDarkMode, fontFactor, const Color(0xFFE57373)),
                  ],
                ),
              ),
              // List
              Expanded(
                child: BlocBuilder<DealsCubit, DealsState>(
                  builder: (context, state) {
                    if (state is DealsLoading) return const Center(child: CircularProgressIndicator());
                    if (state is DealsSuccess) {
                      return ListView.builder(
                        key: ValueKey(state.timestamp),
                        padding: const EdgeInsets.all(16),
                        itemCount: state.deals.length,
                        itemBuilder: (context, index) => DealCard(
                          deal: state.deals[index],
                          fontFactor: fontFactor,
                          isDarkMode: isDarkMode,
                        ),
                      );
                    }
                    return Center(child: Text("deals.no_deals".tr(), style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54)));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(BuildContext context, String key, String value, bool isDarkMode, double fontFactor, Color accent) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        backgroundColor: isDarkMode ? accent.withValues(alpha:  0.1) : Colors.white,
        side: BorderSide(color: isDarkMode ? accent.withValues(alpha: 0.3) : Colors.transparent),
        label: Text(key.tr(), style: TextStyle(fontSize: 12 * fontFactor, color: isDarkMode ? accent : Colors.black87, fontWeight: FontWeight.bold)),
        onPressed: () => context.read<DealsCubit>().filterDeals(value),
      ),
    );
  }
}
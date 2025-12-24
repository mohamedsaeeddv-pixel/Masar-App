import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // أضف هذا
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masar_app/core/constants/app_colors.dart';
import 'package:masar_app/routes/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// استيراد ملفات الإعدادات
import 'features/settings/data/repos/settings_repo_impl.dart';
import 'features/settings/presentation/manager/settings_cubit.dart';
import 'features/settings/presentation/manager/settings_state.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase already initialized or error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. توفير الـ Cubit لكل التطبيق
    return BlocProvider(
      create: (context) => SettingsCubit(SettingsRepoImpl())..loadSettings(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {

          // 2. تحديد اللغة ديناميكياً
          String currentLang = 'ar'; // القيمة الافتراضية
          if (state is SettingsLoaded) {
            currentLang = state.settings.language;
          } else if (state is SettingsUpdated) {
            currentLang = state.settings.language;
          }

          return MaterialApp.router(
            routerConfig: AppRouter.router,

            // 3. تطبيق اللغة المختارة
            locale: Locale(currentLang),

            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // دعم اللغتين عشان الـ Directionality يشتغل صح
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],

            theme: ThemeData(
              fontFamily: 'Arial',
              scaffoldBackgroundColor: AppColors.backgroundLight,
            ),

            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
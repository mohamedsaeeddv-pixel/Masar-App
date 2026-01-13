import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masar_app/features/login/data/repos/auth_repo_impl.dart';
import 'package:masar_app/features/login/presentation/manager/auth_cubit.dart';
import 'package:masar_app/routes/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart'; // ضيف دي
import 'firebase_options.dart';

import 'features/settings/data/repos/settings_repo_impl.dart';
import 'features/settings/presentation/manager/settings_cubit.dart';
import 'features/settings/presentation/manager/settings_state.dart';

import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint("Firebase error: $e");
  }

  runApp(
    // لف التطبيق بـ Phoenix عشان نقدر نعمل Restart
    Phoenix(
      child: EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('ar'),
        startLocale: const Locale('ar'),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsCubit(SettingsRepoImpl())..loadSettings(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(AuthRepoImpl())..checkAuth(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          bool isDark = false;
          double textScale = 1.0;

          // بنقرأ البيانات المحفوظة فقط عند التشغيل
          if (settingsState is SettingsDataState) {
            isDark = (settingsState.settings.themeMode == 'داكن');
            if (settingsState.settings.fontSize == 'كبير') textScale = 1.2;
            if (settingsState.settings.fontSize == 'صغير') textScale = 0.8;

            // ضبط اللغة المحفوظة
            if (context.locale.languageCode != settingsState.settings.language) {
              Future.microtask(() => context.setLocale(Locale(settingsState.settings.language)));
            }
          }

          return BlocBuilder<AuthCubit, AuthCubitState>(
            builder: (context, authState) {
              if (authState is AuthCubitInitial) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
                    body: const Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              return BlocListener<AuthCubit, AuthCubitState>(
                listener: (context, state) {
                  AppRouter.authNotifier.add(null);
                  if (state is AuthCubitUnauthenticated) {
                    AppRouter.router.goNamed('login');
                  }
                },
                child: MaterialApp.router(
                  routerConfig: AppRouter.router,
                  locale: context.locale,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  debugShowCheckedModeBanner: false,
                  themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                  theme: ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.light,
                    textTheme: GoogleFonts.cairoTextTheme(),
                  ),
                  darkTheme: ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.dark,
                    scaffoldBackgroundColor: const Color(0xFF121212),
                    textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: TextScaler.linear(textScale),
                      ),
                      child: child!,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
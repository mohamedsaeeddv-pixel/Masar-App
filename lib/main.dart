import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masar_app/routes/app_router.dart';
// استيراد مكتبات Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // 1. التأكد من تهيئة الـ Widgets
  WidgetsFlutterBinding.ensureInitialized();

  // 2. تهيئة Firebase وحل مشكلة الـ Initialize Error نهائياً
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase already initialized or error: $e");
  }

  // 3. تشغيل التطبيق
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,

      // ضبط اللغة الافتراضية للعربية
      locale: const Locale('ar', 'EG'),

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('ar', 'EG'),
      ],


      theme: ThemeData(
        fontFamily: 'Arial',
      
      ),

      debugShowCheckedModeBanner: false,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Imports للملفات الأساسية فقط
import 'package:masar_app/features/add_client/presentation/screens/add_client_screen.dart';
import 'package:masar_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:masar_app/features/login/presentation/screens/login_screen.dart';
import 'package:masar_app/features/home/presentation/screens/HomeScreen.dart';
import 'package:masar_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:masar_app/features/spalsh/presentation/splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> parentNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: parentNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // 1. شاشة البداية
      GoRoute(
        path: '/',
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // 2. تسجيل الدخول
      GoRoute(
        path: '/login',
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // 3. الشاشة الرئيسية (Home)
      GoRoute(
        path: '/home',
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // 4. الملف الشخصي (Profile)
      GoRoute(
        path: '/profile',
        name: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
        // لاحظ: شيلنا الـ Dashboard والـ Reports من هنا نهائياً
      ),

      // 5. إضافة عميل
      GoRoute(
        path: '/add-client',
        name: AppRoutes.addClient,
        builder: (context, state) => const AddClientScreen(),
      ),

      // 6. المحادثات
      GoRoute(
        path: '/chat',
        name: AppRoutes.chat,
        builder: (context, state) => const ChatScreen(chatId: "chat_001", currentUserId: "HuSskh6q0TfOjVqRXkdSDGqfLlI2"),
      ),

    ],
  );
}
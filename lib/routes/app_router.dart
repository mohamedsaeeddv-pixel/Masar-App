import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --- Imports (Screens) ---
import 'package:masar_app/features/add_client/presentation/screens/add_client_screen.dart';
import 'package:masar_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:masar_app/features/home/presentation/screens/customer_details_screen.dart';
import 'package:masar_app/features/login/presentation/screens/login_screen.dart';
import 'package:masar_app/features/home/presentation/screens/HomeScreen.dart';
import 'package:masar_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:masar_app/features/spalsh/presentation/splash_screen.dart';

// --- Imports (Managers & Repos) ---
import 'package:masar_app/features/login/presentation/manager/login_cubit.dart';
import 'package:masar_app/features/login/data/repos/login_repo_impl.dart';
import 'package:masar_app/features/add_client/presentation/manager/add_client_cubit.dart';
import 'package:masar_app/features/add_client/data/repos/add_client_repo_impl.dart';
import 'package:masar_app/features/chat/presentation/manager/chat_cubit.dart';
import 'package:masar_app/features/chat/data/repos/chats_repo_impel.dart';
import 'package:masar_app/features/home/presentation/manager/home_cubit.dart';

import 'app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> parentNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: parentNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // 1. Splash
      GoRoute(
        path: '/',
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // 2. Login (مغلف بالـ Provider بتاعه)
      GoRoute(
        path: '/login',
        name: AppRoutes.login,
        builder: (context, state) => BlocProvider(
          create: (context) => LoginCubit(LoginRepoImpl()),
          child: const LoginScreen(),
        ),
      ),

      // 3. Home (مغلف بالـ Provider بتاع الـ Navbar)
      GoRoute(
        path: '/home',
        name: AppRoutes.home,
        builder: (context, state) => BlocProvider(
          create: (context) => HomeCubit(),
          child: const HomeScreen(),
        ),
      ),

      // 4. Profile
      GoRoute(
        path: '/profile',
        name: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),

      // 5. Add Client (مغلف بالـ Provider بتاعه)
      GoRoute(
        path: '/add-client',
        name: AppRoutes.addClient,
        builder: (context, state) => BlocProvider(
          create: (context) => AddClientCubit(AddClientRepoImpl()),
          child: const AddClientScreen(),
        ),
      ),

      // 6. Chat (مغلف بالـ Provider والبيانات المطلوبة)
      GoRoute(
        path: '/chat',
        name: AppRoutes.chat,
        builder: (context, state) => BlocProvider(
          create: (context) => ChatCubit(
            repo: ChatsRepoImpl(firestore: FirebaseFirestore.instance),
          )..listenMessages("chat_001"),
          child: const ChatScreen(chatId: "chat_001", currentUserId: "HuSskh6q0TfOjVqRXkdSDGqfLlI2"),
        ),
      ),

      GoRoute(path: '/customer-details', name: AppRoutes.customerDetails, builder: (context, state) => const CustomerDetailsScreen()),
    ],
  );


}






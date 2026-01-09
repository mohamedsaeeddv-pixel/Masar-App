import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --- Imports (Screens) ---
import 'package:masar_app/features/add_client/presentation/screens/add_client_screen.dart';
import 'package:masar_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:masar_app/features/home/presentation/screens/client_details_screen.dart';
import 'package:masar_app/features/home/presentation/screens/map_screen.dart';
import 'package:masar_app/features/login/presentation/screens/login_screen.dart';
import 'package:masar_app/features/home/presentation/screens/home_screen.dart';
import 'package:masar_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:masar_app/features/spalsh/presentation/splash_screen.dart';

// --- Imports (Managers & Repos) ---

import 'package:masar_app/features/add_client/presentation/manager/add_client_cubit.dart';
import 'package:masar_app/features/add_client/data/repos/add_client_repo_impl.dart';
import 'package:masar_app/features/chat/presentation/manager/chat_cubit.dart';
import 'package:masar_app/features/chat/data/repos/chats_repo_impel.dart';
import 'package:masar_app/features/home/presentation/manager/home_cubit.dart';

import 'app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

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
        builder: (context, state) => LoginScreen(),
       
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
  path: '/chat/:agentId',
  name: AppRoutes.chat,
  builder: (context, state) {
    final agentId = state.pathParameters['agentId']!;
    final currentUserId = state.extra as String;

    return BlocProvider(
      create: (_) => ChatCubit(
        repo: ChatsRepoImpl(
          firestore: FirebaseFirestore.instance,
        ),
        chatId: agentId, // chatId == agentId
        currentUserId: currentUserId,
      )..listenMessages(),
      child: ChatScreen(
        chatId: agentId,
        currentUserId: currentUserId,
      ),
    );
  },
),


      GoRoute(
        path: '/client-details',
        name: AppRoutes.clientDetails,
        builder: (context, state) => const ClientDetailsScreen(),
      ),

       GoRoute(
        path: '/map',
        name: AppRoutes.map,
        builder: (context, state) => const MapScreen(),
      ),
    ],
  );
}

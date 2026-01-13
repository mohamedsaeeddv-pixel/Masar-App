import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --- Screens Imports ---
import 'package:masar_app/features/add_client/presentation/screens/add_client_screen.dart';
import 'package:masar_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_model.dart';
import 'package:masar_app/features/home/presentation/screens/client_details_screen.dart';
import 'package:masar_app/features/home/presentation/screens/map/map_screen.dart';
import 'package:masar_app/features/login/presentation/screens/login_screen.dart';
import 'package:masar_app/features/home/presentation/screens/home_screen.dart';
import 'package:masar_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:masar_app/features/spalsh/presentation/splash_screen.dart';

// --- Managers Imports ---
import 'package:masar_app/features/add_client/presentation/manager/add_client_cubit.dart';
import 'package:masar_app/features/add_client/data/repos/add_client_repo_impl.dart';
import 'package:masar_app/features/chat/presentation/manager/chat_cubit.dart';
import 'package:masar_app/features/chat/data/repos/chats_repo_impel.dart';
import 'package:masar_app/features/home/presentation/manager/home_cubit.dart';
import 'package:masar_app/features/login/presentation/manager/auth_cubit.dart';

import 'app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> parentNavigatorKey = GlobalKey<NavigatorState>();

  // 1. وسيط خارجي عشان نبلغ الراوتر بأي تغيير في حالة تسجيل الدخول
  static final StreamController<void> authNotifier = StreamController<void>.broadcast();

  static final GoRouter router = GoRouter(
    navigatorKey: parentNavigatorKey,
    initialLocation: '/home',
    debugLogDiagnostics: true,

    // 2. السطر ده بيخلي الراوتر "يفوق" أول ما نبعت إشارة للـ authNotifier
    refreshListenable: GoRouterRefreshStream(authNotifier.stream),

    redirect: (context, state) {
      final authState = context.read<AuthCubit>().state;
      final bool isLoggingIn = state.matchedLocation == '/login';

      // لو لسه في مرحلة الفحص الأولية
      if (authState is AuthCubitInitial) return null;

      // 3. المنطق القاطع: لو مش مسجل دخول، ارميه على اللوجن فوراً
      if (authState is AuthCubitUnauthenticated) {
        return isLoggingIn ? null : '/login';
      }

      // 4. لو مسجل دخول وبيحاول يروح للوجن، ممنوع
      if (authState is AuthCubitAuthenticated) {
        if (isLoggingIn) return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/splash',
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: AppRoutes.home,
        builder: (context, state) => BlocProvider(
          create: (context) => HomeCubit(),
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        name: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/add-client',
        name: AppRoutes.addClient,
        builder: (context, state) => BlocProvider(
          create: (context) => AddClientCubit(AddClientRepoImpl()),
          child: const AddClientScreen(),
        ),
      ),
      GoRoute(
        path: '/chat/:agentId',
        name: AppRoutes.chat,
        builder: (context, state) {
          final agentId = state.pathParameters['agentId']!;
          final currentUserId = state.extra as String;

          return BlocProvider(
            create: (_) => ChatCubit(
              repo: ChatsRepoImpl(firestore: FirebaseFirestore.instance),
              chatId: agentId, // chatId == agentId
              currentUserId: currentUserId,
            )..listenMessages(),
            child: ChatScreen(chatId: agentId, currentUserId: currentUserId),
          );
        },
      ),
      GoRoute(
        path: '/client-details',
        name: AppRoutes.clientDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          return ClientDetailsScreen(
            clientId: extra['clientId'] as String,
            task: extra['task'] as TaskModel,
            tasks: extra['tasks'] as List<TaskModel>,
          );
        },
      ),
      GoRoute(
        path: '/map',
        name: AppRoutes.map,
        builder: (context, state) {
          final tasks =
              (state.extra as Map<String, dynamic>)['tasks'] as List<TaskModel>;
          return MapScreen(tasks: tasks);
        },
      ),
    ],
  );
}

// كلاس مساعد لتحويل الـ Stream لـ Listenable
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
    );
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
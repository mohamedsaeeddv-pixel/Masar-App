import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:masar_app/features/login/presentation/screens/login_screen.dart';
import 'package:masar_app/features/spalsh/presentation/screens/splash_screen.dart';


// Home
import 'package:masar_app/features/home/presentation/screens/home_screen.dart';
import 'package:masar_app/features/home/presentation/screens/map_screen.dart';
import 'package:masar_app/features/home/presentation/screens/work_details_screen.dart';




// Profile
import 'package:masar_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:masar_app/features/profile/presentation/screens/reports_screen.dart';
import 'package:masar_app/features/profile/presentation/screens/my_data_screen.dart';
import 'package:masar_app/features/profile/presentation/screens/deals_screen.dart';

// More
import 'package:masar_app/features/more/presentation/screens/more_screen.dart';
import 'package:masar_app/features/more/presentation/screens/settings_screen.dart';
import 'package:masar_app/features/more/presentation/screens/add_client_screen.dart';
import 'package:masar_app/features/more/presentation/screens/app_info_screen.dart';

import 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,

    routes: [

      /// Splash
      GoRoute(
        path: '/',
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      /// Login
      GoRoute(
        path: '/login',
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      /// Home
      GoRoute(
        path: '/home',
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
        routes: [

         

          GoRoute(
            path: 'map',
            name: AppRoutes.map,
            builder: (context, state) => const MapScreen(),
          ),

          GoRoute(
            path: 'work-details',
            name: AppRoutes.workDetails,
            builder: (context, state) => const WorkDetailsScreen(),
          ),
        ],
      ),

      /// Profile
      GoRoute(
        path: '/profile',
        name: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
        routes: [

          GoRoute(
            path: 'reports',
            name: AppRoutes.reports,
            builder: (context, state) => const ReportsScreen(),
          ),

          GoRoute(
            path: 'my-data',
            name: AppRoutes.myData,
            builder: (context, state) => const MyDataScreen(),
          ),

          GoRoute(
            path: 'deals',
            name: AppRoutes.deals,
            builder: (context, state) => const DealsScreen(),
          ),
        ],
      ),

      /// More
      GoRoute(
        path: '/more',
        name: AppRoutes.more,
        builder: (context, state) => const MoreScreen(),
        routes: [

          GoRoute(
            path: 'settings',
            name: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),

          GoRoute(
            path: 'add-client',
            name: AppRoutes.addClient,
            builder: (context, state) => const AddClientScreen(),
          ),

          GoRoute(
            path: 'app-info',
            name: AppRoutes.appInfo,
            builder: (context, state) => const AppInfoScreen(),
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          state.error.toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:masar_app/routes/app_router.dart';
import 'features/login/presentation/views/screens/login_screen.dart';
import 'features/more/presentation/views/screens/settings_screen.dart';
import 'features/profile/presentation/views/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: ProfileScreen()
      ),
      // routerConfig: AppRouter.router,
      theme: ThemeData(
    fontFamily: 'Arial',
  ),
    );
  }
}


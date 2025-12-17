import 'package:flutter/material.dart';
import 'package:masar_app/routes/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: ThemeData(
    fontFamily: 'Arial',
  ),
    );
  }
}


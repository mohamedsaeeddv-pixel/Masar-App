import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masar_app/core/constants/assets.dart';
import 'package:masar_app/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // إنشاء الـ Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // نوع الأنيميشن: Scale (تكبير)
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // تشغيل الأنيميشن
    _controller.forward();

    
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        GoRouter.of(context).goNamed(AppRoutes.login);
      });
    
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            AssetsData.logo,
            height: 150,
          ),
        ),
      ),
    );
  }
}

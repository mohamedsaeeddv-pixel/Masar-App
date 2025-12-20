import 'package:flutter/material.dart';
import 'package:masar_app/core/constants/assets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage(AssetsData.logo),
        ),
      )
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../../core/constants/assets.dart';

class LoginHeaderSection extends StatelessWidget {
  const LoginHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: height * 0.05),
        Hero(
          tag: 'logo',
          child: Image.asset(AssetsData.logo, height: height * 0.15),
        ),
        SizedBox(height: height * 0.04),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../../core/constants/assets.dart';

class LoginHeaderSection extends StatelessWidget {
  final double fontFactor;

  const LoginHeaderSection({super.key, required this.fontFactor});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    // فكرة ذكية: بنخلي اللوجو يكبر بنسبة بسيطة (نص الـ factor)
    // عشان لو الخط كبر 1.2 اللوجو ميكبرش زيه بالظبط ويخرب المسافات
    final double logoScale = 1 + (fontFactor - 1) * 0.5;

    return Column(
      children: [
        SizedBox(height: height * 0.05),
        Hero(
          tag: 'logo',
          child: Image.asset(
            AssetsData.logo,
            height: (height * 0.15) * logoScale,
          ),
        ),
        // المسافة بتقل شوية لو الخط كبير عشان الـ Form يظهر بدري
        SizedBox(height: height * (fontFactor > 1 ? 0.02 : 0.04)),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // إضافة الـ Bloc
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../manager/login_cubit.dart'; // استيراد الـ Cubit

class LoginFormBody extends StatelessWidget {
  LoginFormBody({super.key});

  final _formKey = GlobalKey<FormState>();

  // ملاحظة: بما أننا نستخدم Firebase Auth، يفضل تسمية الحقل email وليس username
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Text('مرحباً بك',
              style: AppTextStyles.headline30Regular.copyWith(
                  color: AppColors.bluePrimaryDark,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('تسجيل الدخول إلى حسابك',
              style: AppTextStyles.body16Regular.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 30),

          const Text('البريد الإلكتروني', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          CustomTextField(
            hint: 'example@email.com',
            icon: Icons.email_outlined,
            controller: _emailController,
            // تأكد أن الـ CustomTextField يدعم الـ validator
            validator: (value) {
              if (value == null || value.isEmpty) return 'من فضلك أدخل البريد الإلكتروني';
              if (!value.contains('@')) return 'بريد إلكتروني غير صالح';
              return null;
            },
          ),

          const SizedBox(height: 20),
          const Text('كلمة المرور', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          CustomTextField(
            hint: 'أدخل كلمة المرور',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'من فضلك أدخل كلمة المرور';
              return null;
            },
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                // منطق استعادة كلمة المرور
              },
              child: const Text('نسيت كلمة المرور؟',
                  style: TextStyle(color: AppColors.blueRing, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),

          // هنا نستخدم الـ Cubit عند الضغط
          CustomButton(
            text: 'تسجيل الدخول',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<LoginCubit>().loginUser(
                  email: _emailController.text.trim(),
                  password: _passwordController.text,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
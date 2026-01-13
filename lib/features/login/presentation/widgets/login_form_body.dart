import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masar_app/features/login/presentation/manager/auth_cubit.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class LoginFormBody extends StatelessWidget {
  final double fontFactor;

  LoginFormBody({super.key, required this.fontFactor});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // نعرف إحنا في أنهي Mode عشان الألوان تتغير لحظياً
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          // "مرحباً بك"
          Text('login.welcome'.tr(),
              style: AppTextStyles.headline30Regular.copyWith(
                // في الـ Dark Mode نخلي اللون أفتح شوية عشان يبان
                  color: isDarkMode ? Colors.white : AppColors.bluePrimaryDark,
                  fontSize: 30 * fontFactor,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          // "تسجيل الدخول"
          Text('login.sub_title'.tr(),
              style: AppTextStyles.body16Regular.copyWith(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 16 * fontFactor)),
          const SizedBox(height: 30),

          // الليبل الخاص بالإيميل
          Text('login.email_label'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14 * fontFactor,
                color: isDarkMode ? Colors.white : Colors.black,
              )),
          const SizedBox(height: 10),
          CustomTextField(
            hint: 'login.email_hint'.tr(),
            icon: Icons.email_outlined,
            controller: _emailController,
            // تأكد إن CustomTextField بيقبل ألوان للـ Dark Mode داخلياً
            validator: (value) {
              if (value == null || value.isEmpty) return 'login.email_error_empty'.tr();
              if (!value.contains('@')) return 'login.email_error_invalid'.tr();
              return null;
            },
          ),

          const SizedBox(height: 20),
          // الليبل الخاص بكلمة المرور
          Text('login.password_label'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14 * fontFactor,
                color: isDarkMode ? Colors.white : Colors.black,
              )),
          const SizedBox(height: 10),
          CustomTextField(
            hint: 'login.password_hint'.tr(),
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'login.password_error_empty'.tr();
              return null;
            },
          ),

          Align(
            alignment: AlignmentDirectional.centerStart, // يدعم العربي والإنجليزي أوتوماتيك
            child: TextButton(
              onPressed: () {
                // منطق استعادة كلمة المرور
              },
              child: Text('login.forgot_password'.tr(),
                  style: TextStyle(
                      color: isDarkMode ? AppColors.blueRing.withOpacity(0.8) : AppColors.blueRing,
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * fontFactor)),
            ),
          ),
          const SizedBox(height: 20),

          CustomButton(
            text: 'login.login_button'.tr(),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthCubit>().login(
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
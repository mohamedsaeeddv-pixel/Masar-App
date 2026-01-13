import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masar_app/features/login/presentation/manager/auth_cubit.dart';
import 'package:masar_app/features/settings/presentation/manager/settings_cubit.dart';
import 'package:masar_app/features/settings/presentation/manager/settings_state.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../routes/app_routes.dart';
import '../widgets/login_error_dialog.dart';
import '../widgets/login_form_body.dart';
import '../widgets/login_header_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        // 1. حساب الـ fontFactor
        double fontFactor = 1.0;
        if (settingsState is SettingsDataState) {
          if (settingsState.settings.fontSize == 'كبير') fontFactor = 1.2;
          if (settingsState.settings.fontSize == 'صغير') fontFactor = 0.8;
        }

        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          // استخدام Gradient خفيف في الخلفية بيدي شكل أفخم بكتير
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDarkMode
                    ? [const Color(0xFF0F1115), const Color(0xFF121212)]
                    : [AppColors.bluePrimaryDark.withOpacity(0.1), AppColors.backgroundLight],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // الهيدر (اللوجو والنصوص اللي فوق)
                  LoginHeaderSection(fontFactor: fontFactor),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        // لون الـ Container في الدارك مود لازم يكون فاتح سنة عن الخلفية
                        color: isDarkMode ? const Color(0xFF1A1C23) : AppColors.backgroundWhite,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40), // كبرنا الـ Radius لشكل عصري أكتر
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: BlocConsumer<AuthCubit, AuthCubitState>(
                        listener: (context, state) {
                          if (state is AuthCubitAuthenticated) {
                            context.goNamed(AppRoutes.home);
                          } else if (state is AuthCubitError) {
                            showLoginErrorDialog(context, state.message);
                          }
                        },
                        builder: (context, state) {
                          return AbsorbPointer(
                            absorbing: state is AuthCubitLoading,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  if (state is AuthCubitLoading)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: const LinearProgressIndicator(
                                          backgroundColor: Colors.transparent,
                                          color: AppColors.bluePrimaryDark,
                                          minHeight: 4,
                                        ),
                                      ),
                                    ),

                                  const SizedBox(height: 30), // مساحة إضافية تريح العين

                                  LoginFormBody(fontFactor: fontFactor),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
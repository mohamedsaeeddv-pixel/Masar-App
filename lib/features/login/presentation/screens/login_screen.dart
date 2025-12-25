import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../routes/app_routes.dart';
import '../manager/login_cubit.dart';
import '../widgets/login_error_dialog.dart';
import '../widgets/login_form_body.dart';
import '../widgets/login_header_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            const LoginHeaderSection(),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      context.goNamed(AppRoutes.home);
                    } else if (state is LoginFailure) {
                      showLoginErrorDialog(context, state.errorMessage);
                    }
                  },
                  builder: (context, state) {
                    return AbsorbPointer(
                      // هذا السطر يمنع المستخدم من التفاعل مع الشاشة أثناء التحميل (Clean Code)
                      absorbing: state is LoginLoading,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // شريط تحميل أنيق يظهر فقط وقت التحميل
                            AnimatedOpacity(
                              opacity: state is LoginLoading ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: LinearProgressIndicator(
                                  backgroundColor: AppColors.backgroundLight,
                                  color: AppColors.bluePrimaryDark,
                                ),
                              ),
                            ),
                            LoginFormBody(),
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
    );
  }
}
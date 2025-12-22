import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masar_app/core/utils/app_validators.dart';
import 'package:masar_app/features/login/presentation/manager/auth_cubit.dart';
import 'package:masar_app/routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../../../core/constants/assets.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthCubitState>(
          listener: (context, state) {
            if (state is AuthCubitAuthenticated) {
              // Navigate to home on success
              GoRouter.of(context).goNamed(AppRoutes.home);
            } else if (state is AuthCubitError) {
              // Show error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthCubitLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                SizedBox(height: height * 0.06),
                Image.asset(AssetsData.logo, height: height * 0.16),
                SizedBox(height: height * 0.03),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.025),
                            Text('مرحباً بك', style: AppTextStyles.headline30Regular),
                            const SizedBox(height: 8),
                            const Text('تسجيل الدخول إلى حسابك', style: AppTextStyles.body16Regular),
                            SizedBox(height: height * 0.03),
                            const Text('اسم المستخدم'),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hint: 'أدخل اسم المستخدم',
                              icon: Icons.person_outline,
                              controller: _usernameController,
                              validator: (value) {  return AppValidators.email(value); },
                              onFieldSubmitted: (value) {
                                if (_formKey.currentState!.validate()) {
                                  final email = _usernameController.text.trim();
                                  final password = _passwordController.text.trim();
                                  context.read<AuthCubit>().login(
                                        email: email,
                                        password: password,
                                      );
                                }
                              }
                              ),
                            const SizedBox(height: 16),
                            const Text('كلمة المرور'),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hint: 'أدخل كلمة المرور',
                              icon: Icons.lock_outline_rounded,
                              isPassword: true,
                              controller: _passwordController,
                               validator: (value){
                               return AppValidators.password(value);
                               
                               
                               } ,
                            ),
                            SizedBox(height: height * 0.03),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'نسيت كلمة المرور؟',
                                  style: TextStyle(color: AppColors.blueRing),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            CustomButton(
                              text: 'تسجيل الدخول',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final email = _usernameController.text.trim();
                                  final password = _passwordController.text.trim();
                                  context.read<AuthCubit>().login(
                                        email: email,
                                        password: password,
                                      );
                                }
                              },
                            ),
                            SizedBox(height: height * 0.02),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

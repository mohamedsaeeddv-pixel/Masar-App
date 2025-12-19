import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),

            // 🔷 Logo
            Image.asset(
              AssetsData.logo,
              height: 130,
            ),

            const SizedBox(height: 30),

            // ⬜ Container يأخذ باقي الصفحة
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
                        const SizedBox(height: 20),

                        const Text(
                          'مرحباً بك',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          'تسجيل الدخول إلى حسابك',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),

                        const Text('اسم المستخدم'),
                        const SizedBox(height: 10),

                        CustomTextField(
                          hint: 'أدخل اسم المستخدم',
                          icon: Icons.person_outline,
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'من فضلك أدخل اسم المستخدم';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        const Text('كلمة المرور'),
                        const SizedBox(height: 10),

                        CustomTextField(
                          hint: 'أدخل كلمة المرور',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'من فضلك أدخل كلمة المرور';
                            }
                            if (value.length < 6) {
                              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),

                        const SizedBox(height: 24),

                        CustomButton(
                          text: 'تسجيل الدخول',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // ✅ كل البيانات صح
                              print('Username: ${_usernameController.text}');
                              print('Password: ${_passwordController.text}');
                            }
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
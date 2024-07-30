import 'package:bootcamp91/product/custom_widgets.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/product/project_texts.dart';
import 'package:bootcamp91/services/auth_service.dart';
import 'package:bootcamp91/view/forgat_paswword_screen.dart';
import 'package:bootcamp91/view/regsiter_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final String pageImage = 'assets/images/ic_login_screen.png';

  bool _passwordVisible = false;

  Future<void> _login() async {
    try {
      await _authService.login(
        email: _emailController.text,
        password: _passwordController.text,
        context: context,
      );
    } catch (e) {
      //print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ProjectTexts().loginButton, style: GoogleFonts.kleeOne()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: SizedBox(
                  width: 300,
                  height: 150,
                  child: Image.asset(pageImage),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _emailController,
                      labelText: ProjectTexts().email,
                      inputType: TextInputType.emailAddress,
                    ),
                    const CustomSizedBox(height: 16),
                    CustomTextField(
                      obscureText: !_passwordVisible,
                      controller: _passwordController,
                      labelText: ProjectTexts().password,
                      suffixIcon: IconButton(
                        icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: _passwordVisible
                                ? ProjectColors.project_yellow
                                : ProjectColors.buttonColor),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text(ProjectTexts().loginButton),
                    ),
                    CustomTextButton(
                        toPage: const RegisterScreen(),
                        text: ProjectTexts().loginTextButton),
                    CustomTextButton(
                        toPage: const ForgotPasswordScreen(),
                        text: ProjectTexts().forgotPassword)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

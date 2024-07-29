import 'package:bootcamp91/product/custom_widgets.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/product/project_texts.dart';
import 'package:bootcamp91/view/login_screen.dart';
import 'package:bootcamp91/view/regsiter_screen.dart';
import 'package:flutter/material.dart';

class SecondWelcomeScreen extends StatefulWidget {
  const SecondWelcomeScreen({super.key});

  @override
  State<SecondWelcomeScreen> createState() => _SecondWelcomeScreenState();
}

class _SecondWelcomeScreenState extends State<SecondWelcomeScreen> {
  final String pageImage = 'assets/images/ic_login.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: PaddingContainer(
          child: Column(
            children: [
              const CustomSizedBox(height: 78),
              SizedBox(
                width: 300,
                height: 150,
                child: Image.asset(pageImage),
              ),
              const CustomSizedBox(height: 16),
              CustomText(
                size: 50,
                customColor: ProjectColors.default_color,
                text: ProjectTexts().toGidelim,
              ),
              CustomText(
                  size: 20,
                  customColor: ProjectColors.default_color,
                  text: ProjectTexts().welcome),
              const CustomSizedBox(height: 150),
              CustomButton(
                toPage: const RegisterScreen(),
                title: ProjectTexts().registerButton,
              ),
              const CustomSizedBox(height: 16.0),
              CustomButton(
                title: ProjectTexts().loginButton,
                toPage: const LoginScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaddingContainer extends StatelessWidget {
  final Widget child;
  const PaddingContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: child,
    );
  }
}

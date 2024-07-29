import 'package:bootcamp91/product/custom_widgets.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/product/project_texts.dart';
import 'package:bootcamp91/view/second_welcome_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  // ignore: non_constant_identifier_names
  final String pageImage = 'assets/images/ic_welcome_image.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Geri butonunu gizler
      ),
      body: SingleChildScrollView(
        child: PaddingContainer(
          child: Column(
            children: [
              const CustomSizedBox(height: 64),
              Image.asset(pageImage, width: 100),
              const CustomSizedBox(height: 32),
              CustomText(
                  customColor: ProjectColors.buttonColor,
                  size: 50,
                  text: ProjectTexts().projectName),
              CustomText(
                  size: 18,
                  customColor: ProjectColors.default_color,
                  text: ProjectTexts().welcomeText),
              const CustomSizedBox(height: 256),
              CustomButton(
                title: ProjectTexts().welcomeButtonText,
                toPage: SecondWelcomeScreen(),
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

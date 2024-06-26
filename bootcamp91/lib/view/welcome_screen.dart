import 'package:bootcamp91/product/project_texts.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ProjectTexts().projectName),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 32, right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/images/ic_welcome_image.png"),
            Text(
              textAlign: TextAlign.center,
              ProjectTexts().welcomeText,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(ProjectTexts().welcomeButtonText),
            ),
          ],
        ),
      ),
    );
  }
}

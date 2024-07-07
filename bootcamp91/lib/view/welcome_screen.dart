import 'package:Gidelim/product/project_colors.dart';
import 'package:Gidelim/product/project_texts.dart';
import 'package:Gidelim/view/second_welcome_screen.dart';
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
      backgroundColor: const Color(0xffF2B84B),
      appBar: AppBar(
          // title: Text(ProjectTexts().projectName),
          ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 32, right: 32),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 128.0),
              child: Image.asset("assets/images/ic_welcome_image.png"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                ProjectTexts().projectNameUppercase,
                style: const TextStyle(
                    color: ProjectColors.whiteTextColor,
                    fontSize: 50,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              ProjectTexts().welcomeText,
              style: const TextStyle(
                color: ProjectColors.whiteTextColor,
              ),
            ),
            // Text(
            //   textAlign: TextAlign.center,
            //   ProjectTexts().welcomeText,
            //   style: Theme.of(context).textTheme.bodyLarge,
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 180.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SecondWelcomeScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = const Offset(1.0, 0.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  ); //NAVIGATION FINISH HERE
                },
                child: Text(ProjectTexts().welcomeButtonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

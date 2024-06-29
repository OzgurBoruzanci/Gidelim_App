import 'package:bootcamp91/product/project_texts.dart';
import 'package:bootcamp91/view/feed_screen.dart';
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
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        FeedScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
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
          ],
        ),
      ),
    );
  }
}

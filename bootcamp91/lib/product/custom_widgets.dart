import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSizedBox extends StatelessWidget {
  final double height;
  const CustomSizedBox({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class CustomText extends StatelessWidget {
  final double size;
  final Color customColor;
  final String text;
  const CustomText({
    super.key,
    required this.size,
    required this.customColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.kleeOne(
        color: customColor,
        fontSize: size,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Widget toPage;
  final String title;
  const CustomButton({
    super.key,
    required this.toPage,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => toPage,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Text(title),
    );
  }
}

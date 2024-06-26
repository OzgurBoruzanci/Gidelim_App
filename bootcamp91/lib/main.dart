import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bootcamp91/theme/theme.dart';
import 'package:bootcamp91/view/welcome_screen.dart';

void main() {
  runApp(const MyApp());

  // Status bar rengini burada değiştiriyoruz
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme, // Tema burada kullanılıyor
      home: const WelcomeScreen(),
    );
  }
}

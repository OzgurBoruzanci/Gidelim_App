import 'package:Gidelim/theme/theme.dart';
import 'package:Gidelim/view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

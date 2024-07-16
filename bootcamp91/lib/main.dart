import 'package:bootcamp91/theme/theme.dart';
import 'package:bootcamp91/view/feed_screen.dart';
import 'package:bootcamp91/view/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: _HomeScreen(), // Yönlendirme ekranı
    );
  }
}

class _HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          return const FeedScreen(); // Kullanıcı giriş yapmışsa FeedScreen
        } else {
          return const WelcomeScreen(); // Kullanıcı giriş yapmamışsa WelcomeScreen
        }
      },
    );
  }

  Future<User?> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }
}

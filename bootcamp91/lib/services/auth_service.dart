import 'package:bootcamp91/view/feed_screen.dart';
import 'package:bootcamp91/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    // Boş alan kontrolleri
    if (email.isEmpty) {
      _showSnackBar(context, 'E-posta boş bırakılamaz.', Colors.red);
      return null;
    }
    if (password.isEmpty) {
      _showSnackBar(context, 'Parola boş bırakılamaz.', Colors.red);
      return null;
    }

    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // ignore: use_build_context_synchronously
        _showSnackBar(context, 'Hoş geldin ${user.displayName}!', Colors.green);

        // Kullanıcıyı FeedScreen'e yönlendir
        await Future.delayed(const Duration(seconds: 2));
        // ignore: use_build_context_synchronously
        _navigateToScreen(context, const FeedScreen());
      }
      return user;
    } on FirebaseAuthException catch (e) {
      String message = _getFirebaseAuthErrorMessage(e.code);
      // ignore: use_build_context_synchronously
      _showSnackBar(context, message, Colors.red);
      rethrow;
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showSnackBar(context, 'Bir hata oluştu: $e', Colors.red);
      rethrow;
    }
  }

  // ********************************* REGISTER METHOD *********************************

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    required BuildContext context,
  }) async {
    // Boş değer kontrolleri
    if (displayName.isEmpty) {
      _showSnackBar(context, 'Ad ve soyad boş bırakılamaz.', Colors.red);
      return;
    }
    if (password.isEmpty) {
      _showSnackBar(context, 'Parola boş bırakılamaz.', Colors.red);
      return;
    }

    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateProfile(displayName: displayName);

      // ignore: use_build_context_synchronously
      _showSnackBar(context, 'Kullanıcı başarıyla kaydedildi!', Colors.green);

      // 2 saniye bekle ve LoginScreen'e yönlendir
      await Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      _navigateToScreen(context, const LoginScreen());
    } on FirebaseAuthException catch (e) {
      String message = _getFirebaseAuthErrorMessage(e.code);
      // ignore: use_build_context_synchronously
      _showSnackBar(context, message, Colors.red);
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showSnackBar(context, 'Bir hata oluştu: $e', Colors.red);
    }
  }

  String _getFirebaseAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'Parola çok zayıf.';
      case 'email-already-in-use':
        return 'Bu email ile kayıtlı bir kullanıcı var.';
      case 'invalid-email':
        return 'Geçersiz email adresi.';
      case 'user-not-found':
        return 'Kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Yanlış parola.';
      //For Login
      default:
        return 'Giriş başarısız, lütfen bilgilerinizi kontrol ediniz.';
    }
  }

  void _showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(2.0, 0.0);
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
  }
}

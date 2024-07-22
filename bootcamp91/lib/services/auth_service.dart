import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/view/login_screen.dart';
import 'package:bootcamp91/view/main_screen.dart';
import 'package:bootcamp91/view/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? get currentUserUid => _firebaseAuth.currentUser?.uid;

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
        if (user.emailVerified) {
          _showSnackBar(
              context, 'Hoş geldin ${user.displayName}!', Colors.green);
          _navigateToScreen(context, MainScreen(userUid: user.uid));
        } else {
          _showSnackBar(
              context,
              'Hesap Doğrulanmamış! \nLütfen e-posta adresinizi kontrol edip hesabınızı doğrulayın.',
              Colors.red);
          await _firebaseAuth.signOut();
        }
      }
      return user;
    } on FirebaseAuthException catch (e) {
      String message = _getFirebaseAuthErrorMessage(e.code);
      _showSnackBar(context, message, Colors.red);
      rethrow;
    } catch (e) {
      _showSnackBar(context, 'Bir hata oluştu: $e', Colors.red);
      rethrow;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      _navigateToScreen(context, const WelcomeScreen());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Çıkış yapıldı.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Çıkış yaparken bir hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String passwordAgain,
    required String displayName,
    required BuildContext context,
  }) async {
    // Boş değer kontrolleri
    if (displayName.isEmpty) {
      _showSnackBar(context, 'Ad ve soyad boş bırakılamaz.', Colors.red);
      return;
    }
    if (email.isEmpty) {
      _showSnackBar(context, 'E-posta boş bırakılamaz.', Colors.red);
      return;
    }
    if (password.isEmpty) {
      _showSnackBar(context, 'Parola boş bırakılamaz.', Colors.red);
      return;
    }
    if (password != passwordAgain) {
      _showSnackBar(
          context, 'Parolalar uyuşmuyor, kontrol ediniz.', Colors.red);
      return;
    }

    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await user.updateProfile(displayName: displayName);
        await user.sendEmailVerification();

        _showSnackBar(
            context,
            'Kaydın oluşturuldu $displayName! Size bir doğrulama e-postası gönderdik. \n Lütfen e-posta adresinizi doğrulayın. ',
            Colors.green);

        _navigateToScreen(context, const LoginScreen());
      }
    } on FirebaseAuthException catch (e) {
      String message = _getFirebaseAuthErrorMessage(e.code);
      _showSnackBar(context, message, Colors.red);
    } catch (e) {
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

  Future<void> sendPasswordResetEmail(
      BuildContext context, String email) async {
    if (email.isEmpty) {
      _showSnackBar(context, 'Lütfen E-posta adresinizi giriniz.',
          ProjectColors.red_color);
      return; // E-posta adresi boş olduğunda fonksiyonu sonlandır
    }
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      if (email.isEmpty) {
        _showSnackBar(context, 'Lütfen E-posta adresinizi giriniz.',
            ProjectColors.red_color);
        return; // E-posta adresi boş olduğunda fonksiyonu sonlandır
      }
      _showSnackBar(context, 'Şifre sıfırlama e-postası gönderildi.',
          ProjectColors.green_color);
    } catch (e) {
      _showSnackBar(
          context,
          'Bir hata oluştu: \nGeçerli bir e-posta giriniz. \n${e.toString()}',
          ProjectColors.red_color);
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordAgain,
    required BuildContext context,
  }) async {
    if (newPassword != newPasswordAgain) {
      _showSnackBar(context, 'Yeni parolalar uyuşmuyor!', Colors.red);
      return;
    }
    if (oldPassword.isEmpty ||
        newPassword.isEmpty ||
        newPasswordAgain.isEmpty) {
      _showSnackBar(context, 'Lütfen bilgileri eksiksiz giriniz!', Colors.red);
      return;
    }

    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        _showSnackBar(context, 'Kullanıcı bulunamadı!', Colors.red);
        return;
      }

      String email = user.email!;

      // Kullanıcı yeniden kimlik doğrulaması yapmalı
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      _showSnackBar(context, 'Parola başarıyla güncellendi!', Colors.green);
      Navigator.pop(context); // İşlem başarılı olursa geri dön
    } on FirebaseAuthException catch (e) {
      _showSnackBar(context, 'Hata: ${e.message}', Colors.red);
    } catch (e) {
      _showSnackBar(context, 'Bilinmeyen bir hata oluştu: $e', Colors.red);
    }
  }
}

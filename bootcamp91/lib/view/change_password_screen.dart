import 'package:bootcamp91/product/custom_drawer.dart'; // Yeni eklenen import
import 'package:bootcamp91/product/project_texts.dart';
import 'package:bootcamp91/view/forgat_paswword_screen.dart';
import 'package:flutter/material.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordAgainController =
      TextEditingController();

  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _newPasswordAgainVisible = false;

  Future<void> _changePassword() async {
    final authService = AuthService();
    await authService.changePassword(
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
      newPasswordAgain: _newPasswordAgainController.text,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ProjectTexts().projectName,
          style: GoogleFonts.kleeOne(),
        ),
        actions: [
          Builder(
            builder: (BuildContext context) => IconButton(
              icon: Icon(
                Icons.menu,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // endDrawer'ı açar
              },
            ),
          ),
        ],
      ),
      endDrawer: CustomDrawer(), // CustomDrawer eklendi
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 500,
                  height: 250,
                  child: Image.asset("assets/images/ic_change_password.png"),
                ),
              ),
              TextField(
                controller: _oldPasswordController,
                obscureText: !_oldPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Eski Parola',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _oldPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: _oldPasswordVisible
                          ? ProjectColors.project_yellow
                          : ProjectColors.buttonColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _oldPasswordVisible = !_oldPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _newPasswordController,
                obscureText: !_newPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Yeni Parola',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _newPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: _newPasswordVisible
                            ? ProjectColors.project_yellow
                            : ProjectColors.buttonColor),
                    onPressed: () {
                      setState(() {
                        _newPasswordVisible = !_newPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _newPasswordAgainController,
                obscureText: !_newPasswordAgainVisible,
                decoration: InputDecoration(
                  labelText: 'Yeni Parola Tekrar',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _newPasswordAgainVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: _newPasswordAgainVisible
                            ? ProjectColors.project_yellow
                            : ProjectColors.buttonColor),
                    onPressed: () {
                      setState(() {
                        _newPasswordAgainVisible = !_newPasswordAgainVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(),
                child: const Text('Parolayı Güncelle'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ForgotPasswordScreen(),
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
                  );
                },
                child: Text('Şifremi unuttum'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

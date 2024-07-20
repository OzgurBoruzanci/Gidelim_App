import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/services/auth_service.dart';
import 'package:bootcamp91/product/project_texts.dart';
import 'package:bootcamp91/view/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();
  final TextEditingController _namedController = TextEditingController();

  final AuthService _authService = AuthService(); // AuthService objesi

  bool _passwordVisible = false;
  bool _passwordAgainVisible = false;

  void _register() {
    //Servis ile kayıt işlemi metodu.
    _authService.register(
      email: _emailController.text,
      password: _passwordController.text,
      passwordAgain: _passwordAgainController.text,
      displayName: _namedController.text,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ProjectTexts().register),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: SizedBox(
                  width: 300,
                  height: 150,
                  child: Image.asset("assets/images/ic_register.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _namedController,
                      decoration: InputDecoration(
                        labelText: ProjectTexts().name_surname,
                      ),
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        CapitalizeTextFormatter(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: ProjectTexts().email,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: ProjectTexts().password,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: _passwordVisible
                                ? ProjectColors.project_yellow
                                : ProjectColors.buttonColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_passwordVisible,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordAgainController,
                      decoration: InputDecoration(
                        labelText: ProjectTexts().passwordAgain,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordAgainVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: _passwordAgainVisible
                                ? ProjectColors.project_yellow
                                : ProjectColors.buttonColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordAgainVisible = !_passwordAgainVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_passwordAgainVisible,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _register,
                      child: Text(ProjectTexts().registerButton),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const LoginScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                      child: Text(ProjectTexts().registerTextButton),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CapitalizeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Eğer metin değişmemişse eski değeri döndür
    if (newValue.text == oldValue.text) {
      return newValue;
    }

    // Yeni metni al
    String newText = newValue.text;

    // Metni büyük harflerle formatla
    newText = newText.toLowerCase();
    newText = _capitalizeEachWord(newText);

    // Yeni metin ve seçim aralığını oluştur
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _capitalizeEachWord(String text) {
    return text.split(' ').map((word) {
      if (word.isNotEmpty) {
        // Türkçe karakterler de desteklenir
        return word[0].toUpperCase() + word.substring(1);
      }
      return word;
    }).join(' ');
  }
}

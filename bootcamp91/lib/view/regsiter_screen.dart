import 'package:bootcamp91/product/custom_widgets.dart';
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

  final String pageImage = 'assets/images/ic_register.png';
  final AuthService _authService = AuthService(); // AuthService objesi

  bool _passwordVisible = false;
  bool _passwordAgainVisible = false;

  void _register() {
    // Servis ile kayıt işlemi metodu.
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
        child: PaddingContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const CustomSizedBox(height: 8.0),
              Image.asset(
                pageImage,
                width: 300,
                height: 150,
              ),
              const CustomSizedBox(height: 16.0),
              CustomTextField(
                controller: _namedController,
                labelText: ProjectTexts().name_surname,
                inputType: TextInputType.name,
                inputFormatters: [CapitalizeTextFormatter()],
              ),
              const CustomSizedBox(height: 16.0),
              CustomTextField(
                controller: _emailController,
                labelText: ProjectTexts().email,
                inputType: TextInputType.emailAddress,
              ),
              const CustomSizedBox(height: 16.0),
              CustomTextField(
                controller: _passwordController,
                labelText: ProjectTexts().password,
                obscureText: !_passwordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility_off : Icons.visibility,
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
              const CustomSizedBox(height: 16.0),
              CustomTextField(
                controller: _passwordAgainController,
                labelText: ProjectTexts().passwordAgain,
                obscureText: !_passwordAgainVisible,
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
              const CustomSizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _register,
                child: Text(ProjectTexts().registerButton),
              ),
              const CustomSizedBox(height: 16.0),
              CustomTextButton(
                toPage: const LoginScreen(),
                text: ProjectTexts().registerTextButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaddingContainer extends StatelessWidget {
  final Widget child;
  const PaddingContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: child,
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

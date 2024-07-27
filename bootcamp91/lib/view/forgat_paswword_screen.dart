import 'package:bootcamp91/product/custom_loading_widget.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:bootcamp91/services/auth_service.dart';
import 'package:bootcamp91/product/project_texts.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isSending = false;
  String? _message;

  void _sendPasswordResetEmail() async {
    setState(() {
      _isSending = true;
      _message = null;
    });

    try {
      await _authService.sendPasswordResetEmail(context, _emailController.text);
    } catch (e) {
      setState(() {
        _message = 'E-posta gönderilirken bir hata oluştu: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ProjectTexts().projectName,
          style: GoogleFonts.kleeOne(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 64.0, bottom: 8),
              child: SizedBox(
                  height: 150,
                  width: 300,
                  child: Image.asset("assets/images/forgot_password.png")),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(bottom: 128.0, top: 16, right: 32, left: 32),
              child: Text(
                'Endişelenme, E-posta adresine parolanı yenilemen için bir bağlantı göndereceğiz!',
                textAlign: TextAlign.center,
                style: TextStyle(color: ProjectColors.textColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: ProjectTexts().email,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isSending ? null : _sendPasswordResetEmail,
                    child: _isSending
                        ? const CustomLoadingWidget()
                        : const Text('E-postası Gönder'),
                  ),
                ],
              ),
            ),
            if (_message != null) ...[
              const SizedBox(height: 16),
              Text(
                _message!,
                style: TextStyle(
                  color: _message!.startsWith('Şifre sıfırlama')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

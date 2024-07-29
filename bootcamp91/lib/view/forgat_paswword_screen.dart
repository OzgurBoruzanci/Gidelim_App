import 'package:bootcamp91/product/custom_loading_widget.dart';
import 'package:bootcamp91/product/custom_widgets.dart';
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
  final String pageImage = 'assets/images/forgot_password.png';

  bool _isSending = false;
  String? _message;

  void _sendPasswordResetEmail() async {
    setState(() {
      _isSending = true;
      _message = null;
    });

    try {
      await _authService.sendPasswordResetEmail(context, _emailController.text);
      setState(() {
        _message = ProjectTexts().sendedEmail;
      });
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
        child: PaddingContainer(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                pageImage,
                height: 150,
                width: 300,
              ),
              const CustomSizedBox(height: 8),
              PaddingContainer(
                padding: const EdgeInsets.only(bottom: 128.0, top: 16),
                child: Text(
                  ProjectTexts().forgotPasswordText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: ProjectColors.textColor),
                ),
              ),
              CustomTextField(
                controller: _emailController,
                labelText: ProjectTexts().email,
                inputType: TextInputType.emailAddress,
              ),
              const CustomSizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSending ? null : _sendPasswordResetEmail,
                child: _isSending
                    ? const CustomLoadingWidget()
                    : Text(ProjectTexts().sendEmail),
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
      ),
    );
  }
}

class PaddingContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const PaddingContainer({
    super.key,
    required this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}

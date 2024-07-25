import 'package:bootcamp91/product/project_colors.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sıkça Sorulan Sorular'),
        backgroundColor: ProjectColors.project_yellow,
      ),
      body: ListView(
        children: <Widget>[
          _buildFAQTile(
            question: 'Gidelim ne işe yarar?',
            answer:
                'Uygulama, kullanıcıların kafe menülerini kafelere gitmeden görüntülemesine ve kafeler için yorum yamasına, puan vermesine  olanak sağlar.\nEğer kendi kafeniz var ise, kafenizi uygulamada paylaşarak işletmenizi daha geniş kitlerlere ulaştırmanızı sağlar.',
          ),
          _buildFAQTile(
            question: 'Şifremi nasıl değiştirebilirim ?',
            answer:
                'Şifrenizi değiştirmek için uygulama menüsündeki Profil sayfasını açarak Parolayı Değiştir seçeneğini kullanabilirsiniz.',
          ),
          _buildFAQTile(
            question: 'Şifremi unutursam ne olur?',
            answer:
                'Şifrenizi unutursanız giriş yaparken ekranın altında görünen şifremi unuttum seçeneğini seçmelisiniz.\nArdından E-posta adresinizi girerek yeni bir parola belirlemek için E-posta hesabınıza gelen bağlantıyı kullanabilirsiniz.',
          ),
          _buildFAQTile(
            question: 'Favori kafelerim nerede görünür?',
            answer: 'Favori kafeleriniz "Favorilerim" sekmesinde görünür.',
          ),
          _buildFAQTile(
            question: 'Yorumlar nasıl yapılır?',
            answer:
                'Yorumlarınızı kafeye tıklayınca açılan sayfada bulunan yorum bölümünden yapabilirsiniz.',
          ),
          // Diğer SSS'leri buraya ekleyebilirsiniz.
        ],
      ),
    );
  }

  Widget _buildFAQTile({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(answer),
        ),
      ],
    );
  }
}

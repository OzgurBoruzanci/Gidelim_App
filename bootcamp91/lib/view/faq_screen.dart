import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sıkça Sorulan Sorular',
          style: GoogleFonts.kleeOne(),
        ),
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
            answer:
                'Favori kafeleriniz ana sayfanın en altında yer alan "Favorilerim" sekmesinde görünür.',
          ),
          _buildFAQTile(
            question: 'Yorumlar nasıl yapılır?',
            answer:
                'Yorumlarınızı kafeye tıklayınca açılan sayfada bulunan yorum bölümünden yapabilirsiniz.',
          ),
          _buildFAQTile(
            question: 'Kendi kafemi nasıl Gidelim\'e ekleyebilirim?',
            answer:
                'Sol menü üzerinden "Kafe Oluştur" butonuna tıklayarak, ardından Kafe Oluştur seçeneğini seçip kendi kafeni oluşturabilirsin. \nUNutma ki bir kullanıcı yalnıca bir kafe oluşturabilir.',
          ),
          _buildFAQTile(
            question: 'Kafemdeki ürünlerim neden görünmüyor?',
            answer:
                'Endişelenmeyin, sadece oluşturduğunuz kafenizi bizim onaylamamızı bekleyin. Tarafımızca kafeniz onaylandıktan sonra ürünleriniz görünür hale gelecektir.',
          ),
          _buildFAQTile(
            question: 'Oluşturduğum kafeyi silebilr miyim?',
            answer:
                'Kafenizi silmek için, sol menüde yer alan "Kafe Yönetimi" sekmesini açmalısınız. Ardından sayfanın sağ üst taraında yer alan çöp kutusu ile kafenizi onaylayarak silebilrisiniz. \nUnutmayın ki bu işlem geri alınamaz. ',
          ),
          _buildFAQTile(
            question: 'Avatarımı nasıl değiştirebilirim?',
            answer:
                'Avatarınızı sol menüde yer alan "Profil" sekmesindeki Avatarı Değiştir seçeneği ile kolayca değiştirebilirsiniz.',
          ),
          _buildFAQTile(
            question: 'Kafelerin puanları neye göre belirlenir?',
            answer:
                'Kafelerin puanları, kafe iççin yorum yapan kullanıcıların kafelere verdikleri puanların ortalamasına göre hesaplanır.',
          ),
          _buildFAQTile(
            question: 'Gitmek istediğim kafenin konumunu nasıl görebilirim?',
            answer:
                'Gitmek istediğiniz sayfanın konumunu görebilmek için, kafeye tıklayın ve alt menüde yer alan "Haritada Göster" butonuna tıklayın. Seçtiğiniz kafenin, size en yakın konumu harita üzerinden gösterilecektir. ',
          ),
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
          fontSize: 18,
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

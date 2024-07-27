import 'package:bootcamp91/product/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:bootcamp91/view/add_cafe_screen.dart';
import 'package:bootcamp91/view/my_cafe_screen.dart';

class CreateCafeManagementScreen extends StatelessWidget {
  const CreateCafeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kafe Yönetimi'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Görsel
              Image.asset(
                'assets/images/ic_cafe_managament.png',
                height:
                    300, // Görsel yüksekliği ihtiyacınıza göre ayarlanabilir
                width: 200, // Görsel genişliği ihtiyacınıza göre ayarlanabilir
              ),
              const SizedBox(height: 20.0), // Görsel ile yazı arasında boşluk
              // Kafe oluşturma talimatı
              const Text(
                'Kafenizi Gidelim\'de paylaşın.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0), // Yazı ile buton arasında boşluk
              // Kafe oluştur butonu
              ElevatedButton(
                onPressed: () {
                  _showCafeCreationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  // Buton rengi
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Kafe Oluştur'),
              ),
              const SizedBox(height: 40.0), // Butonlar arasında boşluk
              // Zaten bir kafeniz var mı yazısı
              const Text(
                'Zaten bir kafeniz var mı?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0), // Yazı ile buton arasında boşluk
              // Kafe yönetimi butonu
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyCafeScreen(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  // Buton rengi
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Kafe Yönetimi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCafeCreationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Dikkat!',
            style: TextStyle(
                color: ProjectColors.red_color, fontWeight: FontWeight.bold),
          ),
          content: const Text('Sadece bir tane kafe oluşturabilirsiniz.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'ı kapat
              },
              child: const Text(
                'Vazgeç',
                style: TextStyle(
                    color: ProjectColors.default_color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'ı kapat
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddCafeScreen(),
                ));
              },
              child: const Text(
                'Kafe Oluştur',
                style: TextStyle(
                    color: ProjectColors.default_color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }
}

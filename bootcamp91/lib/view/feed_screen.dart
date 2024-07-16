import 'package:flutter/material.dart';
import 'package:bootcamp91/product/project_texts.dart';
import 'package:bootcamp91/services/auth_service.dart'; // AuthService'i ekleyin

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final AuthService _authService = AuthService(); // AuthService örneği oluştur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(kToolbarHeight + 70), // AppBar yüksekliği
        child: AppBar(
          title: Text(ProjectTexts().projectName),
          automaticallyImplyLeading: false, // Geri butonunu gizler

          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  _authService
                      .signOut(context); // AuthService'ten çıkış yapma çağrısı
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8.0),
                        Text('Çıkış Yap'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],

          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // TextField için yükseklik
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Kafe ara',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white,
          elevation: 5, // Arkadaki gölge
          child: SizedBox(
            width: double.infinity, // Genişliği sayfanın tamamını kaplar
            height: 75, // Yükseklik
            child: Center(
              child: Text(
                'MENÜ', //Veri tabanından gelecek kafe ismi
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

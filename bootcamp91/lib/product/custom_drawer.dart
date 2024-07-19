import 'package:bootcamp91/product/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:bootcamp91/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // Firebase'den mevcut kullanıcıyı al
    User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
            color: ProjectColors.project_yellow,
            height: 80, // DrawerHeader'ın yüksekliği
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    user != null
                        ? user.displayName ?? 'Kullanıcı'
                        : 'Kullanıcı',
                    style: TextStyle(
                        color: ProjectColors.whiteTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop(); // Drawer'ı kapatmak için
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              size: 30,
            ),
            title: Text('Profil'),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 30,
            ),
            title: Text('Çıkış Yap'),
            onTap: () {
              _authService.signOut(context);
              Navigator.of(context).pop(); // Drawer'ı kapatmak için
            },
          ),
        ],
      ),
    );
  }
}

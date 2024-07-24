import 'package:bootcamp91/product/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:bootcamp91/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bootcamp91/services/avatar_service.dart'; // AvatarService'i import ettik
import 'package:bootcamp91/view/profile_screen.dart'; // ProfileScreen'i import ettik
import 'package:url_launcher/url_launcher.dart'; // launch_url paketini import ettik

class CustomDrawer extends StatelessWidget {
  final AuthService _authService = AuthService();
  final AvatarService _avatarService = AvatarService();

  CustomDrawer({super.key}); // AvatarService örneği

  @override
  Widget build(BuildContext context) {
    // Firebase'den mevcut kullanıcıyı al
    User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _avatarService
            .getUserData(), // Avatar verilerini almak için çağırıyoruz
        builder: (context, snapshot) {
          String avatarAsset =
              'assets/images/avatars/default_avatar.png'; // Varsayılan avatar
          String userName = 'Kullanıcı';
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final userData = snapshot.data;
            avatarAsset =
                userData?['avatarAsset'] ?? avatarAsset; // Null kontrolü
            userName = user?.displayName ?? userData?['user_name'] ?? userName;
          }

          return Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
                color: ProjectColors.project_yellow,
                height: 80, // DrawerHeader'ın yüksekliği
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          AssetImage(avatarAsset), // Burada nullable olmamalı
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Text(
                        userName,
                        style: const TextStyle(
                            color: ProjectColors.whiteTextColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop(); // Drawer'ı kapatmak için
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 30,
                ),
                title: const Text('Profil'),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ProfileScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.map_rounded,
                  size: 30,
                ),
                title: const Text('Yakındaki Kafeler'),
                onTap: () async {
                  const url =
                      'https://www.google.com/maps/search/?api=1&query=cafe';
                  if (await launchUrl(Uri.parse(url))) {
                    // Google Haritalar uygulamasını aç
                  } else {
                    // Google Haritalar uygulaması yüklü değilse
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Google Haritalar uygulamasını açamıyor.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  size: 30,
                ),
                title: const Text('Çıkış Yap'),
                onTap: () {
                  _authService.signOut(context);
                  Navigator.of(context).pop(); // Drawer'ı kapatmak için
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

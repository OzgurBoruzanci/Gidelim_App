import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/view/contributers.dart';
import 'package:bootcamp91/view/create_cafe_managament_screen.dart';
import 'package:bootcamp91/view/my_cafe_screen.dart'; // MyCafeScreen'i import ettik
import 'package:flutter/material.dart';
import 'package:bootcamp91/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bootcamp91/services/avatar_service.dart'; // AvatarService'i import ettik
import 'package:bootcamp91/view/profile_screen.dart'; // ProfileScreen'i import ettik
import 'package:bootcamp91/view/faq_screen.dart'; // FAQScreen'i import ettik
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

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffF2B84B), ProjectColors.firstColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
                  height: 150,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: AssetImage(avatarAsset),
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          userName,
                          style: const TextStyle(
                              color: Colors.white,
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
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildAnimatedListTile(
                        icon: Icons.person_outline,
                        title: 'Profil',
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const ProfileScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                      _buildAnimatedListTile(
                        icon: Icons.add_business_outlined,
                        title: 'Kafe Oluştur',
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const CreateCafeManagementScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                      _buildAnimatedListTile(
                        icon: Icons.business_center_outlined,
                        title: 'Kafe Yönetimi',
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    MyCafeScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                      _buildAnimatedListTile(
                        icon: Icons.map_outlined,
                        title: 'Yakındaki Kafeler',
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
                                content: Text(
                                    'Google Haritalar uygulamasını açamıyor.'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                      _buildAnimatedListTile(
                        icon: Icons.help_outline,
                        title: 'SSS',
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const FAQScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                      _buildAnimatedListTile(
                        icon: Icons.group_sharp,
                        title: 'Emeği Geçenler',
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const Contributers(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                      _buildAnimatedListTile(
                        icon: Icons.logout,
                        title: 'Çıkış Yap',
                        onTap: () {
                          _authService.signOut(context);
                          Navigator.of(context).pop(); // Drawer'ı kapatmak için
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      tileColor: Colors.black.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      horizontalTitleGap: 0,
      minVerticalPadding: 12.0,
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
    );
  }
}

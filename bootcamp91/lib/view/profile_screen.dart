import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/services/avatar_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'avatar_selection_screen.dart';
import 'change_password_screen.dart'; // Yeni eklenen import

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AvatarService _avatarService = AvatarService();
  String? _avatarAsset;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _avatarService.getUserData();
      setState(() {
        _avatarAsset = userData?['avatarAsset'] ??
            'assets/images/avatars/default_avatar.png';
        _userEmail = userData?['user_email'] ?? 'E-posta bulunamadı';
      });
    } catch (e) {
      setState(() {
        _avatarAsset = 'assets/images/avatars/default_avatar.png';
        _userEmail = 'E-posta bulunamadı';
      });
    }
  }

  void _showAvatarSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AvatarSelectionScreen(
          onAvatarSelected: (selectedAvatar) async {
            await _avatarService.updateAvatar(selectedAvatar);
            await _loadUserData();
          },
        );
      },
    );
  }

  void _navigateToChangePasswordScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _firebaseAuth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
        backgroundColor: ProjectColors.project_yellow,
        elevation: 0,
      ),
      body: user == null
          ? Center(
              child: Text(
                'Kullanıcı bulunamadı.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.redAccent,
                      fontSize: 18,
                    ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _avatarAsset != null
                        ? AssetImage(_avatarAsset!)
                        : const AssetImage(
                            'assets/images/avatars/default_avatar.png'),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 2.0),
                  TextButton(
                    onPressed: _showAvatarSelectionBottomSheet,
                    child: Text(
                      'Avatarı Değiştir',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ProjectColors.blue_color,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    user.displayName ?? "Kullanıcı",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ProjectColors.textColor,
                        ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    _userEmail ?? "E-posta bulunamadı",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _navigateToChangePasswordScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ProjectColors.buttonColor,
                    ),
                    child: const Text('Parolayı Değiştir'),
                  ),
                ],
              ),
            ),
    );
  }
}

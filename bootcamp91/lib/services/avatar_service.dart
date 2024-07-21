import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvatarService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateAvatar(String avatarPath) async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      final userDocRef = _firestore.collection('users').doc(user.uid);

      try {
        await userDocRef.set({
          'avatarAsset': avatarPath,
          'user_email': user.email ?? '', // E-posta adresini güncelle
        }, SetOptions(merge: true)); // Mevcut verileri koruyarak güncelle
      } catch (e) {
        throw Exception('Avatar güncellenemedi: $e');
      }
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      return userDoc.data();
    }
    return null;
  }
}

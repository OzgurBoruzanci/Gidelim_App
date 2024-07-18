import 'package:cloud_firestore/cloud_firestore.dart';

// Café servisi
class CafeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kafeleri al
  Stream<List<Cafe>> getCafes() {
    return _firestore.collection('cafes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Cafe.fromFirestore(doc)).toList());
  }

  // Belirli bir kafe için menü kategorilerini al
  Stream<List<String>> getMenuCategories(String cafeId) {
    return _firestore
        .collection('cafes')
        .doc(cafeId)
        .collection('menu')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  // Belirli bir kategoriye ait menü öğelerini al
  Stream<List<Drink>> getMenuItems(String cafeId, String category) {
    return _firestore
        .collection('cafes')
        .doc(cafeId)
        .collection('menu')
        .doc(category)
        .collection('items')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Drink.fromFirestore(doc)).toList());
  }

  // Kullanıcının favorilerine kafe ekleme veya çıkarma
  Future<void> toggleFavoriteCafe(
      String userUid, String cafeId, bool isFavorite) async {
    var userFavoritesRef =
        _firestore.collection('users').doc(userUid).collection('user_favorites');

    if (isFavorite) {
      await userFavoritesRef.doc(cafeId).delete();
    } else {
      await userFavoritesRef.doc(cafeId).set({
        'cafe_name': cafeId,
      });
    }
  }

  // Kullanıcının favori kafelerini al
  Stream<List<String>> getUserFavorites(String userUid) {
    return _firestore
        .collection('users')
        .doc(userUid)
        .collection('user_favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  // Belirli bir kafe için verileri al
  Stream<Cafe> getCafe(String cafeId) {
    return _firestore.collection('cafes').doc(cafeId).snapshots().map((snapshot) => Cafe.fromFirestore(snapshot));
  }
}

// Kafe modeli
class Cafe {
  final String id;
  final String name;
  final String logoUrl;

  Cafe({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  factory Cafe.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Cafe(
      id: doc.id,
      name: data['name'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
    );
  }
}

// İçki modeli
class Drink {
  final String name;
  final String imageUrl;
  final double price;

  Drink({
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  factory Drink.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Drink(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] as num).toDouble(),
    );
  }
}

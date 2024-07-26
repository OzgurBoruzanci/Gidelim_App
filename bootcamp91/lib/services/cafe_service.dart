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
    var userFavoritesRef = _firestore
        .collection('users')
        .doc(userUid)
        .collection('user_favorites');

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
    return _firestore
        .collection('cafes')
        .doc(cafeId)
        .snapshots()
        .map((snapshot) => Cafe.fromFirestore(snapshot));
  }

  // Yorum ekleme fonksiyonu
  Future<void> addReview(String cafeId, String userUid, String userName,
      String comment, double rating) async {
    await _firestore.collection('cafes').doc(cafeId).collection('reviews').add({
      'userUid': userUid,
      'userName': userName,
      'comment': comment,
      'rating': rating,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Yorumları getirme fonksiyonu
  Stream<List<Review>> getCafeReviews(String cafeId) {
    return _firestore
        .collection('cafes')
        .doc(cafeId)
        .collection('reviews')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList());
  }

  // Belirli bir kafe için ortalama puanı al
  Future<double> getAverageRating(String cafeId) async {
    try {
      // Kafeye ait yorumlar koleksiyonuna erişiyoruz
      QuerySnapshot reviewsSnapshot = await _firestore
          .collection('cafes')
          .doc(cafeId)
          .collection('reviews')
          .get();

      // Yorum sayısı
      int numberOfReviews = reviewsSnapshot.docs.length;

      // Eğer yorum yoksa, 0 döndür
      if (numberOfReviews == 0) return 0.0;

      // Toplam puanı hesaplıyoruz
      double totalRating = 0.0;
      for (var doc in reviewsSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        totalRating += (data['rating'] as double);
      }

      // Ortalama puanı hesaplıyoruz
      double averageRating = totalRating / numberOfReviews;
      return averageRating;
    } catch (e) {
      // Hata durumunda konsola log atabilir veya başka bir işleme yapabilirsiniz
      print('Error getting average rating: $e');
      return 0.0;
    }
  }

  // Yeni bir kafe oluşturma
  Future<void> createCafe({
    required String cafeName,
    required String cafeDescription,
    required String cafeImageUrl,
    required String creatorUid,
  }) async {
    if (cafeName.isEmpty || cafeDescription.isEmpty || cafeImageUrl.isEmpty) {
      throw ArgumentError('Tüm alanları doldurunuz.');
    }

    try {
      await _firestore.collection('cafes').add({
        'name': cafeName,
        'description': cafeDescription,
        'imageUrl': cafeImageUrl,
        'creatorUid': creatorUid, // Kafe yaratıcısının UID'si
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Hata durumunda konsola log atabilir veya başka bir işleme yapabilirsiniz
      print('Error creating cafe: $e');
    }
  }

  // Kullanıcının kafelerini al
  Future<List<DocumentSnapshot>> getUserCafes(String userUid) async {
    try {
      // Kullanıcıya ait kafeleri getirmek için Firestore sorgusu
      QuerySnapshot querySnapshot = await _firestore
          .collection('cafes')
          .where('ownerUid', isEqualTo: userUid) // Düzeltilmiş
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }

  // Yeni bir kafe ekle
  Future<void> addCafe(String name, String logoUrl, String ownerUid) async {
    try {
      // Yeni bir kafe eklemek için Firestore'a veri ekleme
      await _firestore.collection('cafes').add({
        'name': name,
        'logoUrl': logoUrl,
        'ownerUid': ownerUid, // Düzeltilmiş
      });
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }

  // Kullanıcının kafe bilgilerini al
  Future<Map<String, dynamic>?> getUserCafe(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('cafes')
          .where('ownerUid', isEqualTo: userId) // Düzeltilmiş
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      }
      return null;
    } catch (e) {
      throw Exception('Kafe bilgileri alınırken bir hata oluştu: $e');
    }
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

// Yorum modeli
class Review {
  final String userName;
  final String comment;
  final double rating;
  final Timestamp timestamp; // Firestore Timestamp olarak güncellendi

  Review({
    required this.userName,
    required this.comment,
    required this.rating,
    required this.timestamp,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Review(
      userName: data['userName'] ?? '',
      comment: data['comment'] ?? '',
      rating: (data['rating'] as num).toDouble(),
      timestamp:
          data['timestamp'] as Timestamp, // Firestore Timestamp olarak al
    );
  }
}

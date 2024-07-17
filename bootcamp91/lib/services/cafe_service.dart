import 'package:cloud_firestore/cloud_firestore.dart';

class CafeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Cafe>> getCafes() {
    return _firestore.collection('cafes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Cafe.fromFirestore(doc)).toList());
  }
}

class Cafe {
  final String name;
  final String logoUrl;

  Cafe({required this.name, required this.logoUrl});

  factory Cafe.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Cafe(
      name: data['name'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
    );
  }
}

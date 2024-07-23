import 'package:flutter/material.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:intl/intl.dart'; // Tarih formatlamak için
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // RatingBar için
import 'package:bootcamp91/services/auth_service.dart'; // AuthService'i ekledik
import 'package:bootcamp91/services/avatar_service.dart'; // AvatarService'i ekledik
import 'package:bootcamp91/product/custom_loading_widget.dart'; // Özelleştirilmiş yükleme widget'ını import ettik
import 'package:bootcamp91/product/custom_drawer.dart'; // CustomDrawer'ı import ettik

class ReviewScreen extends StatefulWidget {
  final Cafe cafe;

  const ReviewScreen({super.key, required this.cafe});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final CafeService _cafeService = CafeService();
  final AuthService _authService = AuthService(); // AuthService örneği
  final AvatarService _avatarService = AvatarService(); // AvatarService örneği
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0; // Yıldız puanı
  double _averageRating = 0.0; // Ortalama puan

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // ScaffoldKey

  @override
  void initState() {
    super.initState();
    _fetchAverageRating(); // Ortalama puanı başlat
  }

  Future<void> _fetchAverageRating() async {
    double averageRating = await _cafeService.getAverageRating(widget.cafe.id);
    setState(() {
      _averageRating = averageRating;
    });
  }

  Future<void> _addReview() async {
    if (_reviewController.text.isNotEmpty && _rating > 0) {
      String userUid =
          _authService.currentUserUid ?? 'unknown'; // Kullanıcı UID
      String userName =
          await _authService.getUserDisplayName(); // Kullanıcı adı
      await _cafeService.addReview(
        widget.cafe.id,
        userUid,
        userName,
        _reviewController.text,
        _rating,
      );
      _reviewController.clear();
      setState(() {
        _rating = 0.0; // Reset rating after adding review
        _fetchAverageRating(); // Ortalama puanı güncelle
      });
    } else {
      // Eğer yorum yazılmamışsa ya da puan verilmemişse Snackbar göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _reviewController.text.isEmpty
                ? 'Yorumunuzu yazınız.'
                : 'Yıldız ile puan veriniz.',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ProjectColors.firstColor,
          contentPadding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Kapat dialog
                  },
                  child: const Text(
                    'Vazgeç',
                    style: TextStyle(
                      fontSize: 20,
                      color: ProjectColors.blue_color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reviewController,
                decoration: const InputDecoration(
                  labelText: 'Yorumunuzu yazın',
                  border: OutlineInputBorder(),
                ),
                minLines: 1, // Başlangıçta 1 satır
                maxLines: 5, // Yorum metni uzunluğuna göre büyüsün
                expands: false, // Varsayılan boyutta tut
              ),
              const SizedBox(height: 8),
              RatingBar.builder(
                unratedColor: const Color.fromARGB(244, 169, 168, 168),
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Kapat dialog
                  _addReview(); // Yorumu ekle
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ProjectColors.buttonColor,
                  foregroundColor: ProjectColors.whiteTextColor,
                  elevation: 5,
                ),
                child: const Text('Yorumu Ekle'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // ScaffoldKey atandı
      appBar: AppBar(
        title: const Text('Yorumlar'), //${widget.cafe.name}
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0), // Alt kısım yüksekliği
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: ProjectColors.whiteColor,
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16.0, // Widget'lar arasındaki boşluk
                children: [
                  Text(
                    widget.cafe.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ProjectColors.blue_color,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 16,
                          color: ProjectColors.blue_color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, size: 30),
            onPressed: () {
              _scaffoldKey.currentState
                  ?.openEndDrawer(); // Sağ tarafta drawer'ı aç
            },
          ),
        ],
      ),
      endDrawer: CustomDrawer(), // Sağ tarafa drawer ekledik
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Review>>(
              stream: _cafeService.getCafeReviews(widget.cafe.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(
                    // Özelleştirilmiş yükleme widget'ını kullan
                    child: CustomLoadingWidget(),
                  );
                }

                List<Review> reviews = snapshot.data!;

                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return FutureBuilder<Map<String, dynamic>?>(
                      future: _avatarService.getUserData(),
                      builder: (context, avatarSnapshot) {
                        if (avatarSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (avatarSnapshot.hasData) {
                          final userData = avatarSnapshot.data;
                          final avatarAsset = userData?['avatarAsset'] ??
                              'assets/images/avatars/default_avatar.png'; // Varsayılan avatar

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 5,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 24,
                                  backgroundImage:
                                      AssetImage(avatarAsset), // Avatarı göster
                                  backgroundColor: Colors.grey[200],
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        review.userName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(review.comment),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          review.rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      DateFormat('dd MMM yyyy').format(review
                                          .timestamp
                                          .toDate()), // Tarih formatlama
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                              child: Text('Avatar yüklenemedi.'));
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showReviewDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: ProjectColors.buttonColor,
                foregroundColor: ProjectColors.whiteTextColor,
                elevation: 5,
              ),
              child: const Text('Yorum Yap'),
            ),
          ),
        ],
      ),
    );
  }
}

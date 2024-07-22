import 'package:bootcamp91/view/categoru_items_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/product/custom_loading_widget.dart';
import 'package:bootcamp91/view/review_screen.dart'; // Yorum ekranı için gerekli import

class CafeDetailScreen extends StatefulWidget {
  final Cafe cafe;
  final String userUid;

  const CafeDetailScreen(
      {super.key, required this.cafe, required this.userUid});

  @override
  // ignore: library_private_types_in_public_api
  _CafeDetailScreenState createState() => _CafeDetailScreenState();
}

class _CafeDetailScreenState extends State<CafeDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isFavorite = false;
  final CafeService _cafeService = CafeService();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();

    // AnimationController ve Animation oluşturma
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _checkIfFavorite() async {
    var userFavorites =
        await _cafeService.getUserFavorites(widget.userUid).first;
    setState(() {
      _isFavorite = userFavorites.contains(widget.cafe.id);
    });
  }

  void _toggleFavorite() async {
    await _cafeService.toggleFavoriteCafe(
        widget.userUid, widget.cafe.id, _isFavorite);
    setState(() {
      _isFavorite = !_isFavorite;
    });

    Fluttertoast.showToast(
      msg: _isFavorite
          ? '${widget.cafe.name} \n    Favorilere eklendi   '
          : '${widget.cafe.name} \n    Favorilerden çıkarıldı   ',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: _isFavorite
          ? const Color.fromARGB(216, 233, 30, 98)
          : const Color.fromARGB(163, 38, 38, 38),
      textColor: ProjectColors.whiteTextColor,
      fontSize: 20.0,
    );

    // Animasyonu başlat
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  Future<void> _openGoogleMaps() async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${widget.cafe.name}',
    );

    if (!await launch(googleMapsUrl.toString())) {
      throw 'Could not launch Google Maps: $googleMapsUrl';
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cafe.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      widget.cafe.logoUrl,
                      height: 100.0,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const Center(
                            child: CustomLoadingWidget(),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _openGoogleMaps,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProjectColors.buttonColor,
                    foregroundColor: ProjectColors.whiteTextColor,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text('En Yakın ${widget.cafe.name}'),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewScreen(cafe: widget.cafe),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProjectColors.buttonColor,
                    foregroundColor: ProjectColors.whiteTextColor,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text('Yorumlar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: _cafeService.getMenuCategories(widget.cafe.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CustomLoadingWidget());
                }

                List<String> categories = snapshot.data!;

                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    CategoryItemsScreen(
                              cafe: widget.cafe,
                              category: category,
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin =
                                  Offset(0.0, 1.0); // Aşağıdan yukarıya geçiş
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end);
                              var offsetAnimation = animation
                                  .drive(tween.chain(CurveTween(curve: curve)));

                              return SlideTransition(
                                  position: offsetAnimation, child: child);
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 5,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: SizedBox(
                            height: 135,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    'assets/images/ic_card_bg.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      _getCategoryName(category),
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: ProjectColors.project_gray,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: FloatingActionButton(
              backgroundColor: _isFavorite
                  ? ProjectColors.red_color
                  : ProjectColors.buttonColor,
              onPressed: _toggleFavorite,
              tooltip: _isFavorite ? 'Favorilerden çıkar' : 'Favorilere ekle',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Yuvarlak kenarlar
              ),
              child: Icon(
                size: 35,
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: ProjectColors.whiteColor,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomAppBar(
        height: 40,
        color: ProjectColors.project_yellow,
        shape: CircularNotchedRectangle(),
      ),
    );
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'hot_drinks':
        return 'SICAK İÇECEKLER';
      case 'cold_drinks':
        return 'SOĞUK İÇECEKLER';
      case 'desserts':
        return 'TATLILAR';
      case 'foods':
        return 'YİYECEKLER';
      case 'teas':
        return 'ÇAYLAR';
      default:
        return 'Bilinmeyen Kategori';
    }
  }
}

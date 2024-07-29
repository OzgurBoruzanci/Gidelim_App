import 'package:bootcamp91/product/custom_drawer.dart';
import 'package:bootcamp91/product/project_texts.dart';
import 'package:bootcamp91/view/categoru_items_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // ScaffoldKey

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
      key: _scaffoldKey, // ScaffoldKey atandı
      appBar: AppBar(
        title: Text(
          ProjectTexts().projectName,
          style: GoogleFonts.kleeOne(),
        ),
        // title: Text(widget.cafe.name),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              size: 30,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: CustomDrawer(), // CustomDrawer eklendi
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
                      height: 50.0,
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
                const SizedBox(height: 2.0),
                // Removed previous icon buttons from here
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
                              vertical: 4.0, horizontal: 16.0),
                          child: Card(
                            color: Color.fromARGB(27, 0, 0, 0),
                            elevation: 0, // Daha belirgin gölge
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Daha yuvarlak köşeler
                            ),
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Köşeleri yuvarlatıyoruz
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    _getCategoryName(category),
                                    style: const TextStyle(
                                      fontSize: 22.0, // Daha büyük yazı tipi
                                      fontWeight: FontWeight.bold,
                                      color: ProjectColors
                                          .buttonColor, // Yazı rengini beyaz yapıyoruz
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          )),
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
                borderRadius:
                    BorderRadius.circular(30), // Daha yumuşak yuvarlak köşeler
              ),
              child: Icon(
                size: 30, // İkon boyutunu küçültüyoruz
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: ProjectColors.whiteColor,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 75, // Daha kompakt bir yükseklik
        color: ProjectColors.project_yellow,
        shape: const CircularNotchedRectangle(),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment:
                    MainAxisAlignment.center, // Ortalamayı güncelledik
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(0, 38, 38,
                          38), // Buton üzerindeki metin ve ikon rengi
                      padding: EdgeInsets.zero, // İç boşlukları kaldırıyoruz
                    ),
                    onPressed: _openGoogleMaps,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.map,
                          size: 20, // İkon boyutu
                          color: ProjectColors.buttonColor,
                        ),
                        SizedBox(height: 4), // İkon ve metin arasında boşluk
                        Text(
                          'Haritada Göster',
                          style: TextStyle(
                            color: ProjectColors.buttonColor,
                            fontSize: 12, // Küçük metin boyutu
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment:
                    MainAxisAlignment.center, // Ortalamayı güncelledik
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(0, 38, 38,
                          38), // Buton üzerindeki metin ve ikon rengi
                      padding: EdgeInsets.zero, // İç boşlukları kaldırıyoruz
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            const begin = Offset(1.0, 0.0); // Sağdan sola kayma
                            const end = Offset.zero; // Son konum
                            const curve =
                                Curves.easeInOut; // Animasyonun eğrisi

                            var tween = Tween(begin: begin, end: end);
                            var offsetAnimation = animation
                                .drive(tween.chain(CurveTween(curve: curve)));

                            return SlideTransition(
                              position: offsetAnimation,
                              child: ReviewScreen(cafe: widget.cafe),
                            );
                          },
                        ),
                      );
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.reviews_rounded,
                          size: 20, // İkon boyutu
                          color: ProjectColors.buttonColor,
                        ),
                        SizedBox(height: 4), // İkon ve metin arasında boşluk
                        Text(
                          'Yorumlar',
                          style: TextStyle(
                            color: ProjectColors.buttonColor,
                            fontSize: 12, // Küçük metin boyutu
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'cold_drinks':
        return 'Soğuk İçecekler';
      case 'hot_drinks':
        return 'Sıcak İçecekler';
      case 'desserts':
        return 'Tatlılar';
      case 'foods':
        return 'Yiyecekler';
      case 'teas':
        return 'Çaylar';
      default:
        return 'Diğer';
    }
  }
}

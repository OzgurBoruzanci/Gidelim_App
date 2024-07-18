import 'package:bootcamp91/view/categoru_items_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/product/custom_loading_widget.dart';

class CafeDetailScreen extends StatefulWidget {
  final Cafe cafe;
  final String userUid;

  const CafeDetailScreen({Key? key, required this.cafe, required this.userUid})
      : super(key: key);

  @override
  _CafeDetailScreenState createState() => _CafeDetailScreenState();
}

class _CafeDetailScreenState extends State<CafeDetailScreen> {
  bool _isFavorite = false;
  final CafeService _cafeService = CafeService();

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
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
      msg: _isFavorite ? 'Favorilere eklendi' : 'Favorilerden çıkarıldı',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor:
          _isFavorite ? ProjectColors.green_color : ProjectColors.red_color,
      textColor: ProjectColors.whiteTextColor,
      fontSize: 20.0,
    );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cafe.name),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
              color: _isFavorite
                  ? ProjectColors.red_color
                  : ProjectColors.buttonColor,
              onPressed: _toggleFavorite,
              iconSize: 35,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
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
                          return Center(
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
                  return Center(child: CustomLoadingWidget());
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
                          MaterialPageRoute(
                            builder: (context) => CategoryItemsScreen(
                              cafe: widget.cafe,
                              category: category,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 5,
                          color: Colors.white, // Kart rengi beyaz yapıldı
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Container(
                            height: 135, // Kart yüksekliği 200 olarak ayarlandı
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    'assets/images/ic_card_bg.png',
                                    fit: BoxFit
                                        .contain, // Resim sığacak şekilde ayarlandı
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      _getCategoryName(category),
                                      style: TextStyle(
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
      default:
        return 'Bilinmeyen Kategori';
    }
  }
}

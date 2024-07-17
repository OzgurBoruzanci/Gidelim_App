import 'package:bootcamp91/view/categoru_items_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/product/custom_loading_widget.dart'; // Yeni widget'ı import ettik

class CafeDetailScreen extends StatefulWidget {
  final Cafe cafe;

  const CafeDetailScreen({super.key, required this.cafe});

  @override
  _CafeDetailScreenState createState() => _CafeDetailScreenState();
}

class _CafeDetailScreenState extends State<CafeDetailScreen> {
  // Google Haritalar'ı açacak fonksiyon
  Future<void> _openGoogleMaps() async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${widget.cafe.name}',
    );

    if (!await launchUrl(
      googleMapsUrl,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Google Maps açılamadı: $googleMapsUrl';
    }
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
          // Kafe logosu ve ismi
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.network(
                      widget.cafe.logoUrl,
                      height: 100, // Logo yüksekliği
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _openGoogleMaps,
                  child: Text('En Yakın ${widget.cafe.name}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        ProjectColors.project_gray, // Butonun arka plan rengi
                    foregroundColor: ProjectColors
                        .whiteTextColor, // Buton üzerindeki metin rengi
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: CafeService().getMenuCategories(widget.cafe.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Bir hata oluştu: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return Center(
                      child:
                          CustomLoadingWidget()); // Özelleştirilmiş yükleme widget'ını kullan
                }

                List<String> categories = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          color: ProjectColors.whiteColor,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: Text(
                                _getCategoryName(category),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  color: ProjectColors.project_gray,
                                ),
                              ),
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

  // Kategori isimlerini belirleyen fonksiyon
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

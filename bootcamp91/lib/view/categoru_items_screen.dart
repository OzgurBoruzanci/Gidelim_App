import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:flutter/material.dart';
import 'package:bootcamp91/product/custom_loading_widget.dart'; // Özelleştirilmiş yükleme widget'ını import ettik

class CategoryItemsScreen extends StatelessWidget {
  final Cafe cafe;
  final String category;

  const CategoryItemsScreen({
    super.key,
    required this.cafe,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getCategoryName(category)),
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
                  child: Image.network(
                    cafe.logoUrl,
                    height: 100, // Logo yüksekliği
                  ),
                ),
                // SizedBox(height: 8.0),
                // Center(
                //   child: Text(
                //     cafe.name,
                //     style: Theme.of(context).textTheme.bodyLarge,
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Drink>>(
              stream: CafeService().getMenuItems(cafe.id, category),
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

                List<Drink> drinks = snapshot.data!;
                if (drinks.isEmpty) {
                  return const Center(
                      child: Text('Bu kategoride ürün bulunmuyor.'));
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.7, // Card oranını ayarlayın
                  ),
                  itemCount: drinks.length,
                  itemBuilder: (context, index) {
                    final drink = drinks[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: ProjectColors.whiteColor,
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FutureBuilder(
                                  future: _loadImage(context, drink.imageUrl),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Image.network(
                                        drink.imageUrl,
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return const Center(
                                          child:
                                              CustomLoadingWidget()); // Özelleştirilmiş yükleme widget'ını kullan
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                drink.name,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                '${drink.price} TL',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
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

  Future<void> _loadImage(BuildContext context, String imageUrl) async {
    await precacheImage(NetworkImage(imageUrl), context);
  }

  // Kategori isimlerini belirleyen fonksiyon
  String _getCategoryName(String category) {
    switch (category) {
      case 'hot_drinks':
        return 'Sıcak İçecekler';
      case 'cold_drinks':
        return 'Soğuk İçecekler';
      case 'desserts':
        return 'Tatlılar';
      case 'foods':
        return 'Yiyecekler';
      default:
        return 'Bilinmeyen Kategori';
    }
  }
}

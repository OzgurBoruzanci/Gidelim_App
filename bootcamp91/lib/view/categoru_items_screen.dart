import 'package:bootcamp91/services/cafe_service.dart';
import 'package:flutter/material.dart';

class CategoryItemsScreen extends StatelessWidget {
  final Cafe cafe;
  final String category;

  const CategoryItemsScreen({
    Key? key,
    required this.cafe,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getCategoryName(category)),
      ),
      body: StreamBuilder<List<Drink>>(
        stream: CafeService().getMenuItems(cafe.id, category),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<Drink> drinks = snapshot.data!;
          if (drinks.isEmpty) {
            return Center(child: Text('Bu kategoride ürün bulunmuyor.'));
          }

          return ListView.builder(
            itemCount: drinks.length,
            itemBuilder: (context, index) {
              final drink = drinks[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: Image.network(drink.imageUrl),
                  title: Text(drink.name),
                  subtitle: Text('${drink.price} TL'),
                ),
              );
            },
          );
        },
      ),
    );
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
      default:
        return 'Bilinmeyen Kategori';
    }
  }
}

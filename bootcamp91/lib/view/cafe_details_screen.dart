import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/view/categoru_items_screen.dart';
import 'package:flutter/material.dart';

class CafeDetailScreen extends StatefulWidget {
  final Cafe cafe;

  const CafeDetailScreen({Key? key, required this.cafe}) : super(key: key);

  @override
  _CafeDetailScreenState createState() => _CafeDetailScreenState();
}

class _CafeDetailScreenState extends State<CafeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cafe.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kafe logosu
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Image.network(
                widget.cafe.logoUrl,
                height: 100, // Küçültülmüş logo yüksekliği
              ),
            ),
          ),
          // Kategori kartları
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                  return Center(child: CircularProgressIndicator());
                }

                List<String> categories = snapshot.data!;
                return ListView(
                  children: categories.map((category) {
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(_getCategoryName(category)),
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
                      ),
                    );
                  }).toList(),
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

import 'package:bootcamp91/view/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bootcamp91/services/cafe_service.dart';

class MyCafeScreen extends StatefulWidget {
  @override
  _MyCafeScreenState createState() => _MyCafeScreenState();
}

class _MyCafeScreenState extends State<MyCafeScreen> {
  final CafeService _cafeService = CafeService();
  final String? _userUid = FirebaseAuth.instance.currentUser?.uid;
  bool _isLoading = true;
  Map<String, dynamic>? _cafeDetails;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    if (_userUid != null) {
      _fetchCafeDetails();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCafeDetails() async {
    try {
      final details = await _cafeService.getUserCafe(_userUid!);
      setState(() {
        _cafeDetails = details;
        _isLoading = false;
        _fetchProducts(); // Ürünleri çek
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kafe bilgileri alınırken bir hata oluştu: $e')),
      );
    }
  }

  Future<void> _fetchProducts() async {
    if (_cafeDetails != null) {
      try {
        final products = await _cafeService.getProducts(_cafeDetails!['id']);
        setState(() {
          _products = products;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürünler alınırken bir hata oluştu: $e')),
        );
      }
    }
  }

  Future<void> _deleteProduct(String productId, String category) async {
    if (_cafeDetails != null) {
      try {
        await _cafeService.deleteProduct(
          _cafeDetails!['id'],
          category,
          productId,
        );
        setState(() {
          _products.removeWhere((product) => product['id'] == productId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürün başarıyla silindi!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürün silinirken bir hata oluştu: $e')),
        );
      }
    }
  }

  void _showDeleteConfirmationDialog(String productId, String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ürün Sil'),
          content: Text('Bu ürünü silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteProduct(productId, category);
              },
              child: Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddProductScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(
          cafeId: _cafeDetails!['id'],
          onProductAdded: _fetchProducts,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kafem'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _cafeDetails == null
              ? Center(child: Text('Kafeniz bulunamadı.'))
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Kafe adını ve logosunu göstermek için
                      Text(
                        _cafeDetails!['name'] ?? 'Bilinmiyor',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      _cafeDetails!['logoUrl'] != null
                          ? Image.network(
                              _cafeDetails!['logoUrl']!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : Container(),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _navigateToAddProductScreen,
                        child: Text('Ürün Ekle'),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return Card(
                              child: ListTile(
                                leading: product['imageUrl'] != null
                                    ? Image.network(
                                        product['imageUrl']!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                title: Text(product['name'] ?? 'Bilinmiyor'),
                                subtitle: Text(
                                  '${product['price']?.toStringAsFixed(2) ?? '0.00'} TL',
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () =>
                                      _showDeleteConfirmationDialog(
                                          product['id'], product['category']),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

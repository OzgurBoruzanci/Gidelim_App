import 'package:bootcamp91/product/project_colors.dart';
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

  Future<void> _updateProduct(
    String productId,
    String category,
    String name,
    double price,
    String imageUrl,
  ) async {
    if (_cafeDetails != null) {
      try {
        await _cafeService.updateProduct(
          _cafeDetails!['id'],
          category,
          productId,
          name,
          price,
          imageUrl,
        );
        _fetchProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürün başarıyla güncellendi!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürün güncellenirken bir hata oluştu: $e')),
        );
      }
    }
  }

  void _showDeleteConfirmationDialog(String productId, String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ürün Sil',
            style: TextStyle(
                color: ProjectColors.red_color,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Bu ürünü silmek istediğinizden emin misiniz?',
            style: TextStyle(color: ProjectColors.default_color, fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Vazgeç',
                style:
                    TextStyle(color: ProjectColors.default_color, fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteProduct(productId, category);
              },
              child: Text(
                'Sil',
                style: TextStyle(color: ProjectColors.red_color, fontSize: 18),
              ),
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

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Bilgi',
            style: TextStyle(color: ProjectColors.red_color),
          ),
          content: Text(
              'Eğer ürünleriniz görünmüyor ise lütfen kafenizin onaylanmasını bekleyiniz. \n'
              'Ürünlerinizi eklemeye devam edebilirsiniz, onaylandıktan sonra görünecektir.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Tamam',
                style:
                    TextStyle(color: ProjectColors.default_color, fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditProductDialog(Map<String, dynamic> product) {
    final TextEditingController nameController =
        TextEditingController(text: product['name']);
    final TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    final TextEditingController imageUrlController =
        TextEditingController(text: product['imageUrl']);
    final String category = product['category'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ürünü Düzenle',
            style: TextStyle(color: ProjectColors.default_color),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Ürün Adı'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Ürün Fiyatı'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: 'Ürün Resim URL\'si'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Vazgeç',
                style:
                    TextStyle(color: ProjectColors.default_color, fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () async {
                final String updatedName = nameController.text;
                final double updatedPrice =
                    double.tryParse(priceController.text) ?? 0.0;
                final String updatedImageUrl = imageUrlController.text;

                Navigator.pop(context);
                await _updateProduct(
                  product['id'],
                  category, // Kategori bilgisini ekledik
                  updatedName,
                  updatedPrice,
                  updatedImageUrl,
                );
              },
              child: Text(
                'Güncelle',
                style:
                    TextStyle(color: ProjectColors.default_color, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.firstColor,
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
                      Row(
                        children: [
                          _cafeDetails!['logoUrl'] != null
                              ? Image.network(
                                  _cafeDetails!['logoUrl']!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Container(),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _cafeDetails!['name'] ?? 'Bilinmiyor',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.info_outline),
                            onPressed: _showInfoDialog,
                          ),
                        ],
                      ),
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
                            return GestureDetector(
                              onTap: () => _showEditProductDialog(product),
                              child: Card(
                                color: ProjectColors.whiteColor,
                                child: ListTile(
                                  leading: product['imageUrl'] != null
                                      ? Image.network(
                                          product['imageUrl'],
                                          width: 75,
                                          height: 75,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(),
                                  title: Text(product['name']),
                                  subtitle: Text('\$${product['price']}'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () =>
                                        _showDeleteConfirmationDialog(
                                      product['id'],
                                      product['category'],
                                    ),
                                  ),
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

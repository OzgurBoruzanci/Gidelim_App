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
  bool _isAddingProduct = false;
  Map<String, dynamic>? _cafeDetails;
  List<Map<String, dynamic>> _products = [];

  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'cold_drinks'; // Default value
  String _productName = '';
  String _productImageUrl = '';
  double _productPrice = 0.0;

  List<String> _categories = [
    'Sıcak İçecekler',
    'Soğuk İçecekler',
    'Tatlılar',
    'Çaylar',
    'Yiyecekler',
  ];

  Map<String, String> _categoryMapping = {
    'Sıcak İçecekler': 'hot_drinks',
    'Soğuk İçecekler': 'cold_drinks',
    'Tatlılar': 'desserts',
    'Çaylar': 'teas',
    'Yiyecekler': 'foods',
  };

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

  Future<void> _addProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final categoryValue =
            _categoryMapping[_selectedCategory] ?? 'cold_drinks';
        await _cafeService.addProduct(
          _cafeDetails!['id'],
          categoryValue,
          _productName,
          _productImageUrl,
          _productPrice,
        );
        setState(() {
          _isAddingProduct = false;
          _fetchProducts(); // Ürün eklendikten sonra listeyi güncelle
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürün başarıyla eklendi!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürün eklenirken bir hata oluştu: $e')),
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
                          : SizedBox(
                              width: 150,
                              height: 150,
                              child: Placeholder(),
                            ),
                      SizedBox(height: 20),
                      // Ürün ekleme butonu
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isAddingProduct = !_isAddingProduct;
                          });
                        },
                        child: Text(
                            _isAddingProduct ? 'Formu Kapat' : 'Ürün Ekle'),
                      ),
                      if (_isAddingProduct) ...[
                        // Ürün ekleme formu
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DropdownButtonFormField<String>(
                                value: _categories[0],
                                items: _categories.map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory =
                                        value ?? 'Soğuk İçecekler'; // Default
                                  });
                                },
                                decoration:
                                    InputDecoration(labelText: 'Kategori'),
                                validator: (value) => value == null
                                    ? 'Kategori seçmelisiniz'
                                    : null,
                              ),
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Ürün Adı'),
                                onChanged: (value) => _productName = value,
                                validator: (value) => value!.isEmpty
                                    ? 'Ürün adı boş olamaz'
                                    : null,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Ürün Resim URL\'si'),
                                onChanged: (value) => _productImageUrl = value,
                                validator: (value) => value!.isEmpty
                                    ? 'Resim URL\'si boş olamaz'
                                    : null,
                              ),
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Ürün Fiyatı'),
                                keyboardType: TextInputType.number,
                                onChanged: (value) => _productPrice =
                                    double.tryParse(value) ?? 0.0,
                                validator: (value) =>
                                    value!.isEmpty ? 'Fiyat boş olamaz' : null,
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _addProduct,
                                child: Text('Ürünü Ekle'),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 20),
                      // Ürünleri listeleme
                      Expanded(
                        child: _products.isEmpty
                            ? Center(child: Text('Henüz ürün eklenmemiş.'))
                            : ListView.builder(
                                itemCount: _products.length,
                                itemBuilder: (context, index) {
                                  final product = _products[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    child: ListTile(
                                      leading: Image.network(
                                        product['imageUrl'] ?? '',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                      title:
                                          Text(product['name'] ?? 'Bilinmiyor'),
                                      subtitle:
                                          Text('${product['price'] ?? 0.0} ₺'),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(
                                              product['id'],
                                              _categoryMapping.keys.firstWhere(
                                                (key) =>
                                                    _categoryMapping[key] ==
                                                    product['category'],
                                                orElse: () => 'cold_drinks',
                                              ));
                                        },
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

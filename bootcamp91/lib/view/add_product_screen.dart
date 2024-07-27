import 'package:flutter/material.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProductScreen extends StatefulWidget {
  final String cafeId;
  final Function onProductAdded;

  AddProductScreen({required this.cafeId, required this.onProductAdded});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final CafeService _cafeService = CafeService();
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

  Future<void> _addProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final categoryValue =
            _categoryMapping[_selectedCategory] ?? 'cold_drinks';
        await _cafeService.addProduct(
          widget.cafeId,
          categoryValue,
          _productName,
          _productImageUrl,
          _productPrice,
        );
        widget.onProductAdded();
        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ürün Ekle',
          style: GoogleFonts.kleeOne(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/ic_add_product.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _categories[0],
                        items: _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style:
                                  TextStyle(color: Colors.black), // Siyah renk
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory =
                                value ?? 'Soğuk İçecekler'; // Default
                          });
                        },
                        decoration: InputDecoration(labelText: 'Kategori'),
                        validator: (value) =>
                            value == null ? 'Kategori seçmelisiniz' : null,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Ürün Adı'),
                        onChanged: (value) => _productName = value,
                        validator: (value) =>
                            value!.isEmpty ? 'Ürün adı boş olamaz' : null,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Ürün Resim URL\'si'),
                        onChanged: (value) => _productImageUrl = value,
                        validator: (value) =>
                            value!.isEmpty ? 'Resim URL\'si boş olamaz' : null,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Ürün Fiyatı'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            _productPrice = double.tryParse(value) ?? 0.0,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

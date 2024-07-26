import 'package:flutter/material.dart';

class ProductForm extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final String productName;
  final String productImageUrl;
  final double productPrice;
  final void Function(String?) onCategoryChanged;
  final void Function(String) onNameChanged;
  final void Function(String) onImageUrlChanged;
  final void Function(String) onPriceChanged;
  final VoidCallback onAddProduct;
  final GlobalKey<FormState> formKey;

  ProductForm({
    required this.selectedCategory,
    required this.categories,
    required this.productName,
    required this.productImageUrl,
    required this.productPrice,
    required this.onCategoryChanged,
    required this.onNameChanged,
    required this.onImageUrlChanged,
    required this.onPriceChanged,
    required this.onAddProduct,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            value: categories.first,
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: onCategoryChanged,
            decoration: InputDecoration(labelText: 'Kategori'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Ürün Adı'),
            initialValue: productName,
            onChanged: onNameChanged,
            validator: (value) =>
                value!.isEmpty ? 'Ürün adı boş olamaz' : null,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Ürün Resim URL\'si'),
            initialValue: productImageUrl,
            onChanged: onImageUrlChanged,
            validator: (value) =>
                value!.isEmpty ? 'Resim URL\'si boş olamaz' : null,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Ürün Fiyatı'),
            keyboardType: TextInputType.number,
            initialValue: productPrice.toString(),
            onChanged: onPriceChanged,
            validator: (value) =>
                value!.isEmpty ? 'Fiyat boş olamaz' : null,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onAddProduct,
            child: Text('Ürünü Ekle'),
          ),
        ],
      ),
    );
  }
}

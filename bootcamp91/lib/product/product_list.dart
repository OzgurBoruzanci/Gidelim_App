import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final void Function(String productId, String category) onDeleteProduct;

  ProductList({
    required this.products,
    required this.onDeleteProduct,
  });

  @override
  Widget build(BuildContext context) {
    return products.isEmpty
        ? Center(child: Text('Henüz ürün eklenmemiş.'))
        : ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Image.network(
                    product['imageUrl'] ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product['name'] ?? ''),
                  subtitle: Text(
                      '${product['price']?.toStringAsFixed(2) ?? '0.00'} TL'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => onDeleteProduct(
                      product['id'],
                      product['category'],
                    ),
                  ),
                ),
              );
            },
          );
  }
}

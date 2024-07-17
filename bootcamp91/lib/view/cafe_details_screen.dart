// lib/screens/cafe_details_screen.dart

import 'package:bootcamp91/services/cafe_service.dart';
import 'package:flutter/material.dart';

class CafeDetailScreen extends StatelessWidget {
  final Cafe cafe;

  const CafeDetailScreen({Key? key, required this.cafe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cafe.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(cafe.logoUrl),
            SizedBox(height: 16.0),
            Text(
              cafe.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

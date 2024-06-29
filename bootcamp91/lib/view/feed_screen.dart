import 'package:bootcamp91/product/project_texts.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(kToolbarHeight + 70), // AppBar yüksekliği
        child: AppBar(
          title: Text(ProjectTexts().projectName),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // TextField için yükseklik
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Kafe ara',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Diğer widget'lar buraya eklenebilir
        ],
      ),
    );
  }
}

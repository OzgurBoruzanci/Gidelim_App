import 'package:bootcamp91/services/cafe_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyCafeScreen extends StatefulWidget {
  @override
  _MyCafeScreenState createState() => _MyCafeScreenState();
}

class _MyCafeScreenState extends State<MyCafeScreen> {
  final CafeService _cafeService = CafeService();
  final String? _userUid = FirebaseAuth.instance.currentUser?.uid;
  bool _isLoading = true;
  Map<String, dynamic>? _cafeDetails;

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
              : Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        // Kafe adını ortada büyükçe göstermek için
                        Text(
                          _cafeDetails!['name'] ?? 'Bilinmiyor',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        // Kafe logosunu ortada göstermek için
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
                      ],
                    ),
                  ),
                ),
    );
  }
}

import 'package:bootcamp91/view/cafe_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:bootcamp91/product/project_texts.dart';
import 'package:bootcamp91/services/auth_service.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/product/custom_loading_widget.dart'; // Yeni widget'ı import ettik

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final AuthService _authService = AuthService(); // AuthService örneği oluştur
  final CafeService _cafeService = CafeService(); // CafeService örneği oluştur
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    String text = _searchController.text;
    if (text.isNotEmpty) {
      text = text[0].toUpperCase() + text.substring(1);
    }
    setState(() {
      _searchText = text.toLowerCase();
      _searchController.value = _searchController.value.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(kToolbarHeight + 70), // AppBar yüksekliği
        child: AppBar(
          title: Text(ProjectTexts().projectName),
          automaticallyImplyLeading: false, // Geri butonunu gizler

          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  _authService.signOut(context); // AuthService'ten çıkış yapma çağrısı
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8.0),
                        Text('Çıkış Yap'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0), // TextField için yükseklik
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Kafe ara',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Cafe>>(
        stream: _cafeService.getCafes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Bir hata oluştu'));
          }
          if (!snapshot.hasData) {
            return Center(
              child: CustomLoadingWidget(), // Özelleştirilmiş yükleme widget'ını kullan
            );
          }

          List<Cafe> cafes = snapshot.data!;
          List<Cafe> filteredCafes = cafes.where((cafe) {
            return cafe.name.toLowerCase().contains(_searchText);
          }).toList();

          return ListView.builder(
            itemCount: filteredCafes.length,
            itemBuilder: (context, index) {
              Cafe cafe = filteredCafes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          CafeDetailScreen(cafe: cafe),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: const EdgeInsets.all(8.0), // Kartlar arası boşluk
                  child: Container(
                    height: 150, // Kartın yüksekliğini arttır
                    padding: const EdgeInsets.all(16.0), // Kartın iç kenar boşluğu
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.network(cafe.logoUrl),
                          ),
                        ),
                        const SizedBox(
                            height: 8.0), // Logo ile kafe ismi arası boşluk
                        Text(
                          cafe.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center, // İsmi ortala
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

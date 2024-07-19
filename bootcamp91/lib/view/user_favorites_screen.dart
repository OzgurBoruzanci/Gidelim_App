import 'package:flutter/material.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/view/cafe_details_screen.dart';
import 'package:bootcamp91/product/custom_loading_widget.dart';
import 'package:bootcamp91/services/auth_service.dart';

class UserFavoritesScreen extends StatefulWidget {
  final String userUid;

  const UserFavoritesScreen({required this.userUid});

  @override
  _UserFavoritesScreenState createState() => _UserFavoritesScreenState();
}

class _UserFavoritesScreenState extends State<UserFavoritesScreen> {
  final AuthService _authService = AuthService();
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
      appBar: AppBar(
        title: Text('Favori Kafelerim'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _authService.signOut(context);
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
          preferredSize: const Size.fromHeight(70.0),
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
      body: StreamBuilder<List<String>>(
        stream: CafeService().getUserFavorites(widget.userUid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CustomLoadingWidget());
          }

          List<String> favoriteCafeIds = snapshot.data!;
          if (favoriteCafeIds.isEmpty) {
            return Center(child: Text('Henüz favori kafe yok.'));
          }

          return ListView.builder(
            itemCount: favoriteCafeIds.length,
            itemBuilder: (context, index) {
              String cafeId = favoriteCafeIds[index];
              return StreamBuilder<Cafe>(
                stream: CafeService().getCafe(cafeId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ListTile(
                      title: Text('Hata: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: CustomLoadingWidget(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return ListTile(
                      title: Text('Kafe bulunamadı.'),
                    );
                  }

                  Cafe cafe = snapshot.data!;
                  // Arama metniyle kafe adının tam olarak eşleşip eşleşmediğini kontrol et
                  if (_searchText.isNotEmpty &&
                      !cafe.name.toLowerCase().contains(_searchText)) {
                    return Container(); // Eşleşmiyorsa boş bir Container döndür
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  CafeDetailScreen(
                            cafe: cafe,
                            userUid: widget.userUid,
                          ),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: const EdgeInsets.all(0.0),
                        child: Container(
                          height: 150,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Image.network(cafe.logoUrl),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                cafe.name,
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

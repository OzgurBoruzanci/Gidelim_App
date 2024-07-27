import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/view/cafe_details_screen.dart';
import 'package:bootcamp91/product/custom_drawer.dart';
import 'package:bootcamp91/product/custom_loading_widget.dart';
import 'package:bootcamp91/product/cafe_card.dart'; // CafeCard'ı import ettik

class UserFavoritesScreen extends StatefulWidget {
  final String userUid;

  const UserFavoritesScreen({required this.userUid});

  @override
  _UserFavoritesScreenState createState() => _UserFavoritesScreenState();
}

class _UserFavoritesScreenState extends State<UserFavoritesScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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

  Future<void> _refreshData() async {
    setState(() {
      // Burada, veri yenileme işlemini başlatabilirsiniz.
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstColor = Color(0xffD2C9C0); // firstColor değerini buraya ekleyin

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 70),
        child: AppBar(
          backgroundColor: firstColor, // AppBar arka plan rengini ayarladık
          elevation: 0,
          title: Text(
            'Favori Kafelerim',
            style: GoogleFonts.kleeOne(
              textStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.menu,
                size: 30,
              ),
              onPressed: () {
                _scaffoldKey.currentState
                    ?.openEndDrawer(); // Sağdan Drawer'ı aç
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
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
                  fillColor: Color.fromARGB(118, 255, 255, 255),
                  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                ),
              ),
            ),
          ),
        ),
      ),
      endDrawer: CustomDrawer(), // Sağdan açılan Drawer kullanıldı
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Arka plan rengini ayarlama
          Container(
            color: firstColor, // Arka plan rengini firstColor olarak ayarladık
          ),
          // Diğer içerikler
          NotificationListener<ScrollUpdateNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels <= -50) {
                _refreshIndicatorKey.currentState?.show();
                return true;
              }
              return false;
            },
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh:
                  _refreshData, // Yenileme işlemini gerçekleştirecek fonksiyon
              child: StreamBuilder<List<String>>(
                stream: CafeService().getUserFavorites(widget.userUid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Bir hata oluştu'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child:
                          CustomLoadingWidget(), // CustomLoadingWidget kullanıldı
                    );
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

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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

                          return CafeCard(
                            cafe: cafe,
                            averageRatingFuture:
                                CafeService().getAverageRating(cafe.id),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      CafeDetailScreen(
                                    cafe: cafe,
                                    userUid: widget.userUid,
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

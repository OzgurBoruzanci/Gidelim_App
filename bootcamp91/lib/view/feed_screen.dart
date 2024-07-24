import 'package:flutter/material.dart';
import 'package:bootcamp91/view/cafe_details_screen.dart';
import 'package:bootcamp91/product/custom_drawer.dart';
import 'package:bootcamp91/product/project_texts.dart';
import 'package:bootcamp91/services/auth_service.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/product/custom_loading_widget.dart'; // CustomLoadingWidget'ı import ettik

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final AuthService _authService = AuthService();
  final CafeService _cafeService = CafeService();
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
    // Bu fonksiyon, sayfa yenilendiğinde çalışacak
    setState(() {
      // State'i güncelleyerek verileri yeniden yüklemesini sağlıyoruz
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 70),
        child: AppBar(
          title: Text(ProjectTexts().projectName),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.menu,
                size: 30,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
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
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                ),
              ),
            ),
          ),
        ),
      ),
      endDrawer: CustomDrawer(), // CustomDrawer kullanıldı
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels <= -50) {
            // Ekranın yukarıdan çekilme miktarına göre
            _refreshIndicatorKey.currentState?.show();
            return true;
          }
          return false;
        },
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh:
              _refreshData, // Yenileme işlemini gerçekleştirecek fonksiyon
          child: StreamBuilder<List<Cafe>>(
            stream: _cafeService.getCafes(),
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

              List<Cafe> cafes = snapshot.data!;
              List<Cafe> filteredCafes = cafes.where((cafe) {
                return cafe.name.toLowerCase().contains(_searchText);
              }).toList();

              return ListView.builder(
                itemCount: filteredCafes.length,
                itemBuilder: (context, index) {
                  Cafe cafe = filteredCafes[index];
                  return FutureBuilder<double>(
                    future: _cafeService.getAverageRating(cafe.id),
                    builder: (context, ratingSnapshot) {
                      double averageRating = ratingSnapshot.data ?? 0.0;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      CafeDetailScreen(
                                          cafe: cafe,
                                          userUid: _authService.currentUserUid
                                              .toString()),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
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
                            child: Stack(
                              children: [
                                Container(
                                  height: 150,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Image.network(
                                            cafe.logoUrl,
                                            loadingBuilder:
                                                (context, child, progress) {
                                              if (progress == null) {
                                                return child; // Görsel tamamen yüklendi
                                              } else {
                                                return const Center(
                                                  child:
                                                      CustomLoadingWidget(), // Yükleniyor göstergesi
                                                );
                                              }
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Center(
                                                child:
                                                    Text('Görsel yüklenemedi'),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        cafe.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: ratingSnapshot.connectionState ==
                                          ConnectionState.done
                                      ? Container(
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.white.withOpacity(0.8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                averageRating
                                                    .toStringAsFixed(1),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const CustomLoadingWidget(), // Puan yüklenmiyorsa göster
                                ),
                              ],
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
        ),
      ),
    );
  }
}

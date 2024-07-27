import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/view/cafe_details_screen.dart';
import 'package:bootcamp91/product/custom_drawer.dart';
import 'package:bootcamp91/product/project_texts.dart';
import 'package:bootcamp91/services/auth_service.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/product/custom_loading_widget.dart'; // CustomLoadingWidget'ı import ettik
import 'package:bootcamp91/product/cafe_card.dart'; // CafeCard'ı import ettik

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
          backgroundColor: Color(0xffD2C9C0),
          elevation: 0,
          title: Text(
            ProjectTexts().projectName,
            style: GoogleFonts.kaushanScript(
              textStyle: TextStyle(
                color: ProjectColors.default_color,
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
                  fillColor: Color.fromARGB(118, 255, 255, 255),
                  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                ),
              ),
            ),
          ),
        ),
      ),
      endDrawer: CustomDrawer(), // CustomDrawer kullanıldı
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Arka plan resmi
          Image.asset(
            'assets/images/ic_scaffold.png',
            fit: BoxFit.fitWidth,
          ),
          // Diğer içerikler
          NotificationListener<ScrollUpdateNotification>(
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
                      return CafeCard(
                        cafe: cafe,
                        averageRatingFuture:
                            _cafeService.getAverageRating(cafe.id),
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

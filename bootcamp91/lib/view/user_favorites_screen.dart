import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/product/project_texts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/view/cafe_details_screen.dart';
import 'package:bootcamp91/product/custom_drawer.dart';
import 'package:bootcamp91/product/custom_loading_widget.dart';
import 'package:bootcamp91/product/cafe_card.dart'; // CafeCard'ı import ettik

class UserFavoritesScreen extends StatefulWidget {
  final String userUid;

  const UserFavoritesScreen({super.key, required this.userUid});

  @override
  // ignore: library_private_types_in_public_api
  _UserFavoritesScreenState createState() => _UserFavoritesScreenState();
}

class _UserFavoritesScreenState extends State<UserFavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 70),
        child: AppBar(
          elevation: 0,
          title: Text(
            ProjectTexts().favoriteCafes,
            style: GoogleFonts.kleeOne(
              textStyle: const TextStyle(
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
                  hintText: ProjectTexts().searchCafe,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(118, 255, 255, 255),
                  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                ),
              ),
            ),
          ),
        ),
      ),
      endDrawer: CustomDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: ProjectColors.firstColor,
          ),
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
              onRefresh: _refreshData,
              child: StreamBuilder<List<String>>(
                stream: CafeService().getUserFavorites(widget.userUid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(ProjectTexts().aError));
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CustomLoadingWidget(),
                    );
                  }

                  List<String> favoriteCafeIds = snapshot.data!;
                  if (favoriteCafeIds.isEmpty) {
                    return Center(child: Text(ProjectTexts().noFavoriteCafe));
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
                              title: Text(ProjectTexts().cafeNotFound),
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

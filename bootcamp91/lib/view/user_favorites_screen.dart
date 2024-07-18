import 'package:bootcamp91/view/cafe_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/product/custom_loading_widget.dart';

class UserFavoritesScreen extends StatelessWidget {
  final String userUid;

  const UserFavoritesScreen({required this.userUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favori Kafelerim'),
      ),
      body: StreamBuilder<List<String>>(
        stream: CafeService().getUserFavorites(userUid),
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
                    return ListTile(
                      title: CustomLoadingWidget(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return ListTile(
                      title: Text('Kafe bulunamadı.'),
                    );
                  }

                  Cafe cafe = snapshot.data!;
                  return ListTile(
                    title: Text(cafe.name),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(cafe.logoUrl),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CafeDetailScreen(
                            cafe: cafe,
                            userUid: userUid,
                          ),
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
    );
  }
}

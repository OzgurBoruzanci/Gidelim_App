import 'package:flutter/material.dart';
import 'package:bootcamp91/product/custom_loading_widget.dart';
import 'package:bootcamp91/services/cafe_service.dart';

class CafeCard extends StatelessWidget {
  final Cafe cafe;
  final Future<double> averageRatingFuture;
  final VoidCallback onTap;

  const CafeCard({
    super.key,
    required this.cafe,
    required this.averageRatingFuture,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: Card(
          color: const Color.fromARGB(27, 0, 0, 0),
          elevation: 0, // Gölgesiz
          margin: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(4.0), // İsteğe bağlı: köşe yuvarlaklığı
          ),
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
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) {
                              return child; // Görsel tamamen yüklendi
                            } else {
                              return const Center(
                                child:
                                    CustomLoadingWidget(), // Yükleniyor göstergesi
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text('Görsel yüklenemedi'),
                            );
                          },
                        ),
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
              Positioned(
                bottom: 10,
                right: 10,
                child: FutureBuilder<double>(
                  future: averageRatingFuture,
                  builder: (context, ratingSnapshot) {
                    double averageRating = ratingSnapshot.data ?? 0.0;

                    return ratingSnapshot.connectionState ==
                            ConnectionState.done
                        ? Container(
                            padding: const EdgeInsets.all(8.0),
                            color: const Color.fromARGB(0, 255, 255, 255),
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
                                  averageRating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const CustomLoadingWidget(); // Puan yüklenmiyorsa göster
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

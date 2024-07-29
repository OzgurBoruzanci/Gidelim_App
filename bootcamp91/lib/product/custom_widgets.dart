import 'package:bootcamp91/product/cafe_card.dart';
import 'package:bootcamp91/product/custom_loading_widget.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/product/project_texts.dart';
import 'package:bootcamp91/services/auth_service.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/view/cafe_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSizedBox extends StatelessWidget {
  final double height;
  const CustomSizedBox({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class CustomText extends StatelessWidget {
  final double size;
  final Color customColor;
  final String text;
  const CustomText({
    super.key,
    required this.size,
    required this.customColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.kleeOne(
        color: customColor,
        fontSize: size,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Widget toPage;
  final String title;
  const CustomButton({
    super.key,
    required this.toPage,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => toPage,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Text(title),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final Widget toPage;
  final String text;
  const CustomTextButton({
    super.key,
    required this.toPage,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => toPage,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Text(text),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.inputType = TextInputType.text,
    this.inputFormatters,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
      ),
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
    );
  }
}
//********************************** FEED SCREEN START ******************************************* */

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final TextEditingController searchController;

  const CustomAppBar({
    Key? key,
    required this.scaffoldKey,
    required this.searchController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        ProjectTexts().projectName,
        style: GoogleFonts.kleeOne(
          textStyle: const TextStyle(
            color: ProjectColors.default_color,
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, size: 30),
          onPressed: () {
            scaffoldKey.currentState?.openEndDrawer();
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Kafe ara',
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 70);
}

class CafeList extends StatelessWidget {
  final CafeService cafeService;
  final String searchText;
  final AuthService authService;

  const CafeList({
    Key? key,
    required this.cafeService,
    required this.searchText,
    required this.authService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Cafe>>(
      stream: cafeService.getCafes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Bir hata oluştu'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CustomLoadingWidget());
        }

        List<Cafe> cafes = snapshot.data!;
        List<Cafe> filteredCafes = cafes.where((cafe) {
          return cafe.name.toLowerCase().contains(searchText);
        }).toList();

        return ListView.builder(
          itemCount: filteredCafes.length,
          itemBuilder: (context, index) {
            Cafe cafe = filteredCafes[index];
            return CafeCard(
              cafe: cafe,
              averageRatingFuture: cafeService.getAverageRating(cafe.id),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        CafeDetailScreen(
                            cafe: cafe,
                            userUid: authService.currentUserUid.toString()),
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
            );
          },
        );
      },
    );
  }
}
//********************************** FEED SCREEN FINISH ******************************************* */


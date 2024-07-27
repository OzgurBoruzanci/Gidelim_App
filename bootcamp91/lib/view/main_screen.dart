import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/view/feed_screen.dart';
import 'package:bootcamp91/view/user_favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemNavigator için import

class MainScreen extends StatefulWidget {
  final String userUid;

  const MainScreen({required this.userUid});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  DateTime? _lastPressedTime;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<bool> _onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButtonHasNotBeenPressedOrSnackBarHasBeenDismissed =
        _lastPressedTime == null ||
            currentTime.difference(_lastPressedTime!) > Duration(seconds: 2);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenDismissed) {
      _lastPressedTime = currentTime;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kapatmak için tekrar basın.'),
          backgroundColor: ProjectColors.buttonColor,
          duration: Duration(seconds: 1),
        ),
      );
      return Future.value(false); // Geri tuşu işlem yapılmıyor
    }
    // Uygulama kapanır
    SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: [
            FeedScreen(),
            UserFavoritesScreen(userUid: widget.userUid),
          ],
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ProjectColors.firstColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.coffee, size: 30),
              label: 'Tüm Kafeler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, size: 30),
              label: 'Favorilerim',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: ProjectColors.project_yellow,
          unselectedItemColor: ProjectColors.default_color,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}

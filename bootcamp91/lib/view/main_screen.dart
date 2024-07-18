import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/view/feed_screen.dart';
import 'package:bootcamp91/view/user_favorites_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final String userUid;

  const MainScreen({required this.userUid});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: ProjectColors.project_yellow,
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
        selectedItemColor: ProjectColors.buttonColor,
        unselectedItemColor: Colors.white,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}

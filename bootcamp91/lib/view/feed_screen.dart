import 'package:flutter/material.dart';
import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/product/custom_drawer.dart';
import 'package:bootcamp91/services/auth_service.dart';
import 'package:bootcamp91/services/cafe_service.dart';
import 'package:bootcamp91/product/custom_widgets.dart'; // CustomWidgets'ı import ettik

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
        searchController: _searchController,
      ),
      endDrawer: CustomDrawer(),
      body: Container(
        color: ProjectColors.firstColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
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
                child: CafeList(
                  cafeService: _cafeService,
                  searchText: _searchText,
                  authService: _authService,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

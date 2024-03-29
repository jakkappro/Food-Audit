import 'package:flutter/material.dart';
import 'package:food_audit/pages/home/pages/settings/settings.dart';

import '../camera/camera_page.dart';
import '../search/search_page.dart';
import 'pages/home.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({Key? key}) : super(key: key);

  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Widget> _children = [
    const Home(),
    CameraPage(),
    const SearchPage(),
    SettingsPage(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentPage = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        currentIndex: _currentPage,
        elevation: 0,
        showSelectedLabels: false,
        items: <BottomNavigationBarItem>[
          _buildDestination(
            Icons.home_outlined,
            'Home',
            Icons.home,
          ),
          _buildDestination(
            Icons.document_scanner_outlined,
            'Camera',
            Icons.document_scanner,
          ),
          _buildDestination(
            Icons.search_outlined,
            'Search',
            Icons.search,
          ),
          _buildDestination(
            Icons.settings_outlined,
            'Settings',
            Icons.settings,
          )
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildDestination(
      IconData icon, String label, IconData selectedIcon) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      activeIcon: Icon(
        selectedIcon,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: label,
    );
  }
}

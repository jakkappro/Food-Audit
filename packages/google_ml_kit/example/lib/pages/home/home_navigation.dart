import 'package:flutter/material.dart';

import '../camera/camera_page.dart';
import '../../home_pages/settings_page.dart';
import 'pages/home.dart';

class HomeNavigation extends StatefulWidget {
  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Widget> _children = [
    Home(),
    CameraPage(),
    SettingsPage(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(40, 48, 70, 1),
            Color.fromRGBO(60, 78, 104, 1),
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color.fromRGBO(105, 140, 17, 1),
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
              Icons.settings_outlined,
              'Settings',
              Icons.settings,
            )
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildDestination(
      IconData icon, String label, IconData selectedIcon) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Icon(selectedIcon),
      label: label,
    );
  }
}

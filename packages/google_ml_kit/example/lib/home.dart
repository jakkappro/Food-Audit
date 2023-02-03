import 'package:flutter/material.dart';

import 'home_pages/camera_page.dart';
import 'home_pages/home_page.dart';
import 'home_pages/settings_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Widget> _children = [
    HomePage(),
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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView(
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        children: _children,
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            left: width * 0.05,
            right: width * 0.05,
            bottom: 20,
          ),
          child: Row(
            children: [
              Container(
                  width: width * 0.9,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    color: Colors.black,
                  ),
                  child: NavigationBar(
                    height: 55,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                        _currentPage = index;
                      });
                    },
                    labelBehavior:
                        NavigationDestinationLabelBehavior.alwaysHide,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    selectedIndex: _currentPage,
                    destinations: const <Widget>[
                      NavigationDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.document_scanner_outlined),
                        selectedIcon: Icon(Icons.document_scanner),
                        label: 'Camera',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings),
                        label: 'Settings',
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

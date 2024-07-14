import 'package:cineconnect/features/search/search_ui.dart';
import 'package:cineconnect/features/trending_movies_shows/trending_ui.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavigationScaffold extends StatefulWidget {
  const BottomNavigationScaffold({super.key});

  @override
  State<BottomNavigationScaffold> createState() =>
      _BottomNavigationScaffoldState();
}

class _BottomNavigationScaffoldState extends State<BottomNavigationScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.fiber_smart_record_outlined),
            title: const Text("Trending"),
            selectedColor: Colors.teal.withOpacity(0.8),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.south_america_sharp),
            title: const Text("Search"),
            selectedColor: Colors.teal.withOpacity(0.8),
          ),
        ],
      ),
      body: _currentIndex == 0 ? const TrendingScreen() : const SearchScreen(),
    );
  }
}

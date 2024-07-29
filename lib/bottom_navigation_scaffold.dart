import 'package:cineconnect/features/book_reader/libgen_ui.dart';
import 'package:cineconnect/features/movies_and_shows/trending_movies_shows/trending_ui.dart';
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
            icon: const Icon(Icons.other_houses_rounded),
            title: const Text("Home"),
            selectedColor: Colors.teal.withOpacity(0.8),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.travel_explore_rounded),
            title: const Text("Search"),
            selectedColor: Colors.teal.withOpacity(0.8),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.book_rounded),
            title: const Text("Books"),
            selectedColor: Colors.teal.withOpacity(0.8),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.mp_rounded),
            title: const Text("Manga"),
            selectedColor: Colors.teal.withOpacity(0.8),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.podcasts_rounded),
            title: const Text("Rooms"),
            selectedColor: Colors.teal.withOpacity(0.8),
          ),
        ],
      ),
      body: _currentIndex == 0
          ? const HomeScreen()
          : _currentIndex == 2
              ? const LibGenScreen()
              : const Center(
                  child: Text("Coming Soon"),
                ),
    );
  }
}

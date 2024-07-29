import 'package:cineconnect/features/book_reader/book_controller.dart';
import 'package:cineconnect/features/book_reader/book_library.dart';
import 'package:cineconnect/features/book_reader/book_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LibGenScreen extends StatefulWidget {
  const LibGenScreen({super.key});

  @override
  State<LibGenScreen> createState() => _LibGenScreenState();
}

class _LibGenScreenState extends State<LibGenScreen>
    with TickerProviderStateMixin {
  BookController controller = Get.put(BookController());
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(104),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text(
                "Books",
                style: GoogleFonts.quicksand(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  text: "Search",
                ),
                Tab(
                  text: "Library",
                )
              ],
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BookSearch(
            controller: controller,
          ),
          BookLibrary(
            controller: controller,
          )
        ],
      ),
    );
  }
}

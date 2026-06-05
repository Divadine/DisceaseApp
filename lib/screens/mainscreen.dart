import 'package:discese_dictionary/screens/search_screen.dart';
import 'package:discese_dictionary/screens/video_showing_screen.dart';
import 'package:discese_dictionary/sharedwidgtes/bottom_naviagtion_bar.dart';
import 'package:flutter/material.dart';

import 'bookmark_screen.dart';
import 'disceasedict_homeScreen.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int selectedindex = 0;

  void onItemTapped(int index) async {
    setState(() {
      selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: IndexedStack(index: selectedindex, children: screens),
      body: switch (selectedindex) {
        0 => DisceaseDictionary(),
        1 => SearchScreen(category: [], diseaseList: []),
        2 => VideoShowingScreen(name: 'Reels', videos: []),
        3 => BookmarkScreen(),
        _ => DisceaseDictionary(),
      },
      //bottom
      bottomNavigationBar: SafeArea(
        child: CustomBottomNavigationBar(
          currentIndex: selectedindex,
          onTap: (index) {
            setState(() {
              selectedindex = index;
            });
          },
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/providers/auth_provider.dart';
import 'package:task/views/home/explore_page.dart';
import 'package:task/views/home/library_page.dart';
import 'package:task/views/profile/user_profile.dart';
import 'package:task/util/search_bar.dart';
import 'package:task/views/upload/record_video.dart';
import 'package:task/views/upload/upload_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  int _selectedIndex = 0;
  Widget build(BuildContext context) {
    final authSerivce = ref.watch<AuthService>(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Assignment"),
        actions: [
          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfilePage(),
                )),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(
                  authSerivce.currentUser.photoURL ??
                      "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541",
                  errorListener: () {}),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body:
          [const ExplorePage(), const LibraryPage()].elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (value) => setState(() {
                _selectedIndex = value;
              }),
          items: const [
            BottomNavigationBarItem(
                label: 'Explore', icon: Icon(Icons.explore_outlined)),
            BottomNavigationBarItem(
                label: 'Library', icon: Icon(Icons.home_max_rounded)),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoRecorderScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

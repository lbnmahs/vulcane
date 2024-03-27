import 'package:flutter/material.dart';

import 'package:vulcane/models/user_model.dart';
import 'package:vulcane/views/screens/home/favorites_screen.dart';
import 'package:vulcane/views/screens/home/home_screen.dart';
import 'package:vulcane/views/screens/home/profile_screen.dart';
import 'package:vulcane/views/screens/home/search_screen.dart';
import 'package:vulcane/views/widgets/user_avatar.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key, required this.currentUser});

  final VulcaneUser currentUser;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _screenIndex = 0;
  late List<Widget> _homePages;

  @override
  void initState() {
    super.initState();
    _homePages = [
      const HomeScreen(),
      const SearchScreen(),
      const FavoritesScreen(),
      ProfileScreen(user: widget.currentUser,)
    ];
  }

  void _onTabItemSelect (int index) => setState(() => _screenIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _homePages.elementAt(_screenIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
          const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(
            icon: UserAvatar(
              imageUrl: widget.currentUser.profileImageUrl ?? '',
              radius: 20.0,
              name: widget.currentUser.fullName
            ),
            label: 'Profile'
          ),
        ],
        currentIndex: _screenIndex,
        onTap: _onTabItemSelect,
        selectedItemColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
        unselectedItemColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _screenIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online_rounded), label: 'Tickets'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active_rounded), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _screenIndex,
        onTap: (int index) {},
        selectedItemColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
        unselectedItemColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        backgroundColor: const Color(0xFF0A372F),
        selectedItemColor: const Color(0xFF4A7C7E),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 1 ? Icons.collections : Icons.collections_outlined),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 2 ? Icons.diamond : Icons.diamond_outlined),
            label: 'Rings',
          ),
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 3 ? Icons.shopping_bag : Icons.shopping_bag_outlined),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 4 ? Icons.person : Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
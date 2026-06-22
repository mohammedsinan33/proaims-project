import 'package:flutter/material.dart';
import '../components/app_bar.dart';
import '../components/hero_section.dart';
import '../components/price_rating_section.dart';
import '../components/categories_section.dart';
import '../components/featured_section.dart';
import '../components/collections_section.dart';
import '../components/bottom_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeroSection(),
            PriceRatingSection(),
            CategoriesSection(),
            FeaturedSection(),
            CollectionsSection(),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
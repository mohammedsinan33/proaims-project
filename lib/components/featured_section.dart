import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeaturedSection extends StatefulWidget {
  const FeaturedSection({Key? key}) : super(key: key);

  @override
  State<FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<FeaturedSection> {
  List<dynamic> products = [];
  bool isLoading = true;
  String errorMessage = '';
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fetchFeaturedProducts();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchFeaturedProducts() async {
    try {
      final response = await http
          .get(Uri.parse('https://thangals.schemeapp.com/api/categoryList'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✓ Featured Products Fetch Success!');
        
        List<dynamic> productList = [];
        
        if (data is Map && data['data'] != null && data['data'] is Map) {
          if (data['data']['Latest_product_list'] != null && 
              data['data']['Latest_product_list'] is List) {
            productList = data['data']['Latest_product_list'];
          }
        }
        
        print('Total Featured Products: ${productList.length}');
        
        setState(() {
          products = productList;
          isLoading = false;
        });
        
        _startAutoSlide();
      } else {
        setState(() {
          errorMessage = 'Failed to load products';
          isLoading = false;
        });
        print('API Error: Status Code ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      print('Exception: $e');
    }
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && products.isNotEmpty) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Featured Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (errorMessage.isNotEmpty)
            SizedBox(
              height: 300,
              child: Center(child: Text('Error: $errorMessage')),
            )
          else if (products.isEmpty)
            const SizedBox(
              height: 300,
              child: Center(child: Text('No products available')),
            )
          else
            Column(
              children: [
                SizedBox(
                  height: 350,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index % products.length;
                      });
                    },
                    itemBuilder: (context, index) {
                      final product = products[index % products.length];
                      final productName = product['product_name'] ?? 'Unknown';
                      final description = product['description'] ?? 'No description';
                      final productImage = product['product_image'] ?? '';
                      final imageUrl =
                          'https://thangals.schemeapp.com/storage/$productImage';
                      final stars = (product['stars'] ?? 0).toDouble();

                      return ProductCarouselCard(
                        name: productName,
                        description: description,
                        imageUrl: imageUrl,
                        stars: stars,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    products.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.amber
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ProductCarouselCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final double stars;

  const ProductCarouselCard({
    Key? key,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.stars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              },
            ),
            // Dark Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Product Info Overlay
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Star Rating
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < stars.toInt()
                              ? Icons.star
                              : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${stars.toInt()} stars',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({Key? key}) : super(key: key);

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  List<dynamic> categories = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http
          .get(Uri.parse('https://thangals.schemeapp.com/api/categoryList'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✓ API Fetch Success!');
        print('Full Response: $data');
        
        List<dynamic> categoryList = [];
        
        // Extract category_list from nested data.data structure
        if (data is Map && data['data'] != null && data['data'] is Map) {
          if (data['data']['category_list'] != null && data['data']['category_list'] is List) {
            categoryList = data['data']['category_list'];
          }
        }
        
        print('Total Categories: ${categoryList.length}');
        for (int i = 0; i < categoryList.length; i++) {
          final category = categoryList[i];
          print('Category $i: ID=${category['id']}, Name=${category['category']}, Image=${category['category_image']}');
        }
        
        setState(() {
          categories = categoryList;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load categories';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (errorMessage.isNotEmpty)
            SizedBox(
              height: 80,
              child: Center(child: Text('Error: $errorMessage')),
            )
          else if (categories.isEmpty)
            const SizedBox(
              height: 80,
              child: Center(child: Text('No categories available')),
            )
          else
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final categoryId = category['id'];
                  final categoryName = category['category'] ?? 'Unknown';
                  final categoryImage = category['category_image'] ?? '';
                  final imageUrl =
                      'https://thangals.schemeapp.com/storage/$categoryImage';

                  return CategoryItem(
                    id: categoryId,
                    name: categoryName,
                    imageUrl: imageUrl,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final int id;
  final String name;
  final String imageUrl;

  const CategoryItem({
    Key? key,
    required this.id,
    required this.name,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 80,
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
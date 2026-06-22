import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CollectionsSection extends StatefulWidget {
  const CollectionsSection({Key? key}) : super(key: key);

  @override
  State<CollectionsSection> createState() => _CollectionsSectionState();
}

class _CollectionsSectionState extends State<CollectionsSection> {
  List<dynamic> products = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCollections();
  }

  Future<void> fetchCollections() async {
    try {
      final response = await http
          .get(Uri.parse('https://thangals.schemeapp.com/api/AllProductList'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✓ Collections Fetch Success!');
        print('Full API Response: $data');
        
        List<dynamic> productList = [];
        
        // Try different response structures
        if (data is Map && data['All_product_list'] != null && 
            data['All_product_list'] is List) {
          productList = data['All_product_list'];
        } else if (data is Map && data['data'] != null && data['data'] is Map) {
          if (data['data']['All_product_list'] != null && 
              data['data']['All_product_list'] is List) {
            productList = data['data']['All_product_list'];
          }
        }
        
        print('Total Products: ${productList.length}');
        for (int i = 0; i < productList.length; i++) {
          final product = productList[i];
          print('Product $i: Name=${product['product_name']}, Image=${product['product_image']}');
        }
        
        setState(() {
          products = productList;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load collections';
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
            'Collections',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const SizedBox(
              height: 400,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (errorMessage.isNotEmpty)
            SizedBox(
              height: 400,
              child: Center(child: Text('Error: $errorMessage')),
            )
          else if (products.isEmpty)
            const SizedBox(
              height: 400,
              child: Center(child: Text('No collections available')),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final productName = product['product_name'] ?? 'Unknown';
                final description = product['description'] ?? 'No description';
                final productImage = product['product_image'] ?? '';
                final imageUrl =
                    'https://thangals.schemeapp.com/storage/$productImage';

                return CollectionCard(
                  title: productName,
                  subtitle: description,
                  imageUrl: imageUrl,
                  discount: '10% Off',
                );
              },
            ),
        ],
      ),
    );
  }
}

class CollectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String discount;

  const CollectionCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.discount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Badge
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey),
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
                // Discount Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      discount,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Forward Arrow
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product Info
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
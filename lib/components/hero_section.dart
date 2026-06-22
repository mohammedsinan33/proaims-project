import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HeroSection extends StatefulWidget {
  const HeroSection({Key? key}) : super(key: key);

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  late Future<DashboardData> dashboardData;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    dashboardData = fetchDashboardData();
    _pageController = PageController();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ============ Fetch API Data ============
  Future<DashboardData> fetchDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse('https://thangals.schemeapp.com/api/dashboard/2'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return DashboardData.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  // ============ Auto Slide Function ============
  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        int nextPage = (_currentPage + 1) % 2; // 2 images total
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardData>(
      future: dashboardData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: const Color(0xFFB3A693),
            padding: const EdgeInsets.all(20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pearl Collection',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Explore our exclusive pearl jewelry collection',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 16),
                CircularProgressIndicator(color: Colors.white),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            color: const Color(0xFFB3A693),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pearl Collection',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Explore our exclusive pearl jewelry collection',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          final images = data.getImages();

          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 280,
              child: Stack(
                children: [
                  // ============ Full Background Image Carousel ============
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                      _startAutoSlide();
                    },
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[400],
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // ============ Dark Overlay ============
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // ============ Text Overlay ============
                  Positioned(
                    left: 20,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Pearl Collection',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 250,
                          child: Text(
                            data.bannerContent?.bannerContent ??
                                'Explore our exclusive pearl jewelry collection',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ============ Indicator Dots ============
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 12 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

// ============ Data Models ============
class DashboardData {
  final BannerContent? bannerContent;
  final List<BannerImage> bannerImages;
  final List<SchemeImage> schemeImages;

  DashboardData({
    required this.bannerContent,
    required this.bannerImages,
    required this.schemeImages,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      bannerContent: json['banner_content'] != null
          ? BannerContent.fromJson(json['banner_content'])
          : null,
      bannerImages: (json['banner_image'] as List)
          .map((item) => BannerImage.fromJson(item))
          .toList(),
      schemeImages: (json['scheme_image'] as List)
          .map((item) => SchemeImage.fromJson(item))
          .toList(),
    );
  }

  // Get all image URLs - direct, no proxy
  List<String> getImages() {
    List<String> images = [];

    // Add banner images
    for (var img in bannerImages) {
      images.add('https://thangals.schemeapp.com/storage/${img.bannerImage}');
    }

    // Add scheme images
    for (var img in schemeImages) {
      images.add('https://thangals.schemeapp.com/storage/${img.bannerImage}');
    }

    return images;
  }
}

class BannerImage {
  final int id;
  final String bannerImage;

  BannerImage({required this.id, required this.bannerImage});

  factory BannerImage.fromJson(Map<String, dynamic> json) {
    return BannerImage(
      id: json['id'],
      bannerImage: json['banner_image'],
    );
  }
}

class SchemeImage {
  final int id;
  final String bannerImage;

  SchemeImage({required this.id, required this.bannerImage});

  factory SchemeImage.fromJson(Map<String, dynamic> json) {
    return SchemeImage(
      id: json['id'],
      bannerImage: json['banner_image'],
    );
  }
}

class BannerContent {
  final String bannerContent;

  BannerContent({required this.bannerContent});

  factory BannerContent.fromJson(Map<String, dynamic> json) {
    return BannerContent(
      bannerContent: json['banner_content'] ?? '',
    );
  }
}
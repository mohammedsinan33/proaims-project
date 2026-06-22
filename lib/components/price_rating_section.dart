import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PriceRatingSection extends StatefulWidget {
  const PriceRatingSection({Key? key}) : super(key: key);

  @override
  State<PriceRatingSection> createState() => _PriceRatingSectionState();
}

class _PriceRatingSectionState extends State<PriceRatingSection> {
  Map<String, dynamic>? goldRateData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchGoldRateData();
  }

  Future<void> fetchGoldRateData() async {
    try {
      final response = await http
          .get(Uri.parse('https://thangals.schemeapp.com/api/dashboard/2'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API Response: $data'); // DEBUG: See full response
        
        // Try to access nested data if it's under a 'data' key
        final goldData = data['data'] ?? data;
        print('Gold Data: $goldData'); // DEBUG: See parsed data
        
        setState(() {
          goldRateData = goldData;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  double calculatePercentageChange(String today, String previous) {
    try {
      double todayValue = double.parse(today);
      double previousValue = double.parse(previous);
      return ((todayValue - previousValue) / previousValue) * 100;
    } catch (e) {
      return 0;
    }
  }

  String getTodayDate() {
    return DateFormat('dd MMMM yyyy').format(DateTime.now()).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text('Error: $errorMessage'));
    }

    if (goldRateData == null) {
      return const Center(child: Text('No data available'));
    }

    final todayRate = goldRateData!['todayRate'] ?? '0';
    final carat18Rate = goldRateData!['todayRate 18 carat gold'] ?? '0';
    final previousRate = goldRateData!['gram_previous'] ?? '0';
    final previousCarat18Rate = goldRateData!['gram_previous 18 carat gold'] ?? '0';

    final percentageChange =
        calculatePercentageChange(todayRate, previousRate);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ============ Gold Rate Card ============
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7BF97),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFF7BF97),
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // ============ Coins Icon ============
                Column(
                  children: [
                    Image.asset(
                      'assets/Coins.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // ============ Title & Date ============
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gold Rate',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      getTodayDate(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // ============ Divider ============
                    Container(
                      width: 100,
                      height: 1,
                      color: Colors.black26,
                    ),
                  ],
                ),
                const Spacer(),

                // ============ Price Display (Horizontal) ============
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 1 Gram Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '₹${todayRate}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          '1 Gram',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    // 18 Carat Gold Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '₹${carat18Rate}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          '18 Carat',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // ============ Percentage Change ============
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      percentageChange.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Icon(
                      percentageChange >= 0
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 20,
                      color: percentageChange >= 0
                          ? Colors.green[700]
                          : Colors.red[700],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ============ Tags Section ============

        ],
      ),
    );
  }
}

class TagChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const TagChip({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D4B8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF8B6F47)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8B6F47),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:krishi_ai/View/bottom_nav_bar.dart';
import '../services/market_prices_service.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final Color primary = const Color(0xFF59F20D);
  final Color backgroundDark = const Color(0xFF162210);
  final Color surfaceDark = const Color(0xFF1E2923);

  bool _isLoading = true;
  Map<String, dynamic>? _marketData;
  String? _errorMessage;
  String _location = "India";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLocationAndPrices();
  }

  Future<void> _fetchLocationAndPrices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Try to get current location
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        final Position position = await Geolocator.getCurrentPosition();
        final List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks[0];
          _location = place.locality ?? place.administrativeArea ?? "India";
        }
      }
    } catch (e) {
      print('Error getting location: $e');
    }

    // Fetch market prices
    await _fetchMarketPrices();
  }

  Future<void> _fetchMarketPrices({String commodity = ''}) async {
    try {
      final result = await MarketPricesService.fetchMarketPrices(
        location: _location,
        commodity: commodity,
      );

      if (mounted) {
        setState(() {
          _marketData = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: surfaceDark,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.storefront_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Market Prices",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _isLoading
                            ? null
                            : () => _fetchMarketPrices(
                                commodity: _searchController.text,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  TextField(
                    controller: _searchController,
                    style: GoogleFonts.inter(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search commodity (e.g., Tomato, Wheat)",
                      hintStyle: GoogleFonts.inter(color: Colors.grey[600]),
                      filled: true,
                      fillColor: surfaceDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search, color: primary),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: primary),
                        onPressed: () {
                          _fetchMarketPrices(commodity: _searchController.text);
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      _fetchMarketPrices(commodity: value);
                    },
                  ),
                ],
              ),
            ),

            // Content
            Expanded(child: _buildContent()),
          ],
        ),
      ),
      bottomNavigationBar: const KrishiBottomNav(currentIndex: 3),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: primary));
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                "Error",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _fetchLocationAndPrices,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: backgroundDark,
                ),
                child: Text('Retry', style: GoogleFonts.inter()),
              ),
            ],
          ),
        ),
      );
    }

    if (_marketData == null || (_marketData!['prices'] as List).isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[600]),
              const SizedBox(height: 16),
              Text(
                "No prices found",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Try searching for a different commodity",
                style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    final prices = _marketData!['prices'] as List;
    final location = _marketData!['location'] ?? _location;
    final lastUpdated = _marketData!['last_updated'] ?? 'Recently';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Updated: $lastUpdated',
                        style: GoogleFonts.inter(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Prices list
          Text(
            "Market Prices",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ...prices.map((price) => _buildPriceCard(price)).toList(),
        ],
      ),
    );
  }

  Widget _buildPriceCard(Map<String, dynamic> price) {
    final commodity = price['commodity'] ?? 'Unknown';
    final variety = price['variety'] ?? '';
    final unit = price['unit'] ?? 'Quintal';
    final minPrice = price['min_price'] ?? 0;
    final maxPrice = price['max_price'] ?? 0;
    final modalPrice = price['modal_price'] ?? 0;
    final market = price['market'] ?? '';
    final trend = price['trend'] ?? 'stable';

    Color trendColor = Colors.grey;
    IconData trendIcon = Icons.remove;
    if (trend == 'rising') {
      trendColor = primary;
      trendIcon = Icons.trending_up;
    } else if (trend == 'falling') {
      trendColor = Colors.red;
      trendIcon = Icons.trending_down;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commodity,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (variety.isNotEmpty)
                      Text(
                        variety,
                        style: GoogleFonts.inter(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    if (market.isNotEmpty)
                      Text(
                        market,
                        style: GoogleFonts.inter(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(trendIcon, color: trendColor, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    trend.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: trendColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceInfo('Min', '₹$minPrice'),
              _buildPriceInfo('Modal', '₹$modalPrice', isHighlight: true),
              _buildPriceInfo('Max', '₹$maxPrice'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'per $unit',
            style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            color: isHighlight ? primary : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cache_service.dart';

class MarketPricesService {
  static const String backendUrl =
      'https://mor-backend-4i9u.onrender.com/market-prices';
  static final CacheService _cache = CacheService();

  static Future<Map<String, dynamic>> fetchMarketPrices({
    required String location,
    String commodity = '',
    bool forceRefresh = false,
  }) async {
    // Create cache key based on location and commodity
    final cacheKey = 'market_prices_${location}_$commodity';

    // Try to get from cache first (unless force refresh)
    if (!forceRefresh) {
      final cachedData = await _cache.getFromCache(cacheKey);
      if (cachedData != null) {
        print('📦 Using cached market prices for $location');
        return cachedData as Map<String, dynamic>;
      }
    }

    http.Client? client;
    try {
      client = http.Client();

      print('=== MARKET PRICES: Fetching data ===');
      print('Location: $location');
      print('Commodity: $commodity');

      final response = await client
          .post(
            Uri.parse(backendUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'location': location, 'commodity': commodity}),
          )
          .timeout(
            const Duration(seconds: 120),
            onTimeout: () {
              throw Exception('Request timed out');
            },
          );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if this is an error response with raw_response
        if (data['raw_response'] != null &&
            data['prices'] is List &&
            (data['prices'] as List).isEmpty) {
          print('Backend returned error response with raw_response');
          throw Exception(
            'Backend failed to parse response: ${data['detail'] ?? "Unknown error"}',
          );
        }

        // Validate prices field
        if (!data.containsKey('prices')) {
          throw Exception('Response missing prices field');
        }

        // Save to cache
        await _cache.saveToCache(cacheKey, data);

        print('Successfully fetched ${(data['prices'] as List).length} prices');
        return data;
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Bad request');
      } else if (response.statusCode == 500) {
        final errorData = json.decode(response.body);
        throw Exception(
          'Server error: ${errorData['detail'] ?? "Unknown error"}',
        );
      } else {
        throw Exception(
          'Failed to fetch market prices: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching market prices: $e');
      throw Exception('Failed to fetch market prices: $e');
    } finally {
      client?.close();
    }
  }

  /// Clear market prices cache for a specific location
  static Future<void> clearMarketCache(
    String location,
    String commodity,
  ) async {
    final cacheKey = 'market_prices_${location}_$commodity';
    await _cache.clearCache(cacheKey);
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cache_service.dart';

class GovSchemesService {
  static const String backendUrl =
      'https://mor-backend-4i9u.onrender.com/gov-schemes';
  static final CacheService _cache = CacheService();

  static Future<Map<String, dynamic>> fetchSchemes({
    String state = "All States",
    String type = "All Types",
    bool forceRefresh = false,
  }) async {
    // Create cache key based on filters
    final cacheKey = 'gov_schemes_${state}_$type';

    // Try to get from cache first (unless force refresh)
    if (!forceRefresh) {
      final cachedData = await _cache.getFromCache(cacheKey);
      if (cachedData != null) {
        print('📦 Using cached schemes data');
        return cachedData as Map<String, dynamic>;
      }
    }

    http.Client? client;
    try {
      client = http.Client();

      print('=== GOV SCHEMES: Fetching schemes ===');
      print('State: $state');
      print('Type: $type');
      print('URL: $backendUrl');

      final response = await client
          .post(
            Uri.parse(backendUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'state': state, 'type': type}),
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
        if (data['raw_response'] != null) {
          print('Backend returned error response with raw_response');
          throw Exception(
            'Backend failed to parse response: ${data['detail'] ?? "Unknown error"}',
          );
        }

        // Validate schemes field
        if (!data.containsKey('schemes')) {
          throw Exception('Response missing schemes field');
        }

        print(
          'Successfully fetched ${(data['schemes'] as List).length} schemes',
        );

        // Save to cache
        await _cache.saveToCache(cacheKey, data);

        return data;
      } else if (response.statusCode == 500) {
        final errorData = json.decode(response.body);
        throw Exception(
          'Server error: ${errorData['detail'] ?? "Unknown error"}',
        );
      } else {
        throw Exception('Failed to fetch schemes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching schemes: $e');
      throw Exception('Failed to fetch schemes: $e');
    } finally {
      client?.close();
    }
  }
}

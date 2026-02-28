import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cache_service.dart';

class WeatherAdvisoryService {
  static const String backendUrl =
      'https://mor-backend-4i9u.onrender.com/weather-crop-advisory';
  static final CacheService _cache = CacheService();

  static Future<Map<String, dynamic>> fetchWeatherAdvisory({
    required String city,
    String state = '',
    String country = 'IN',
    bool forceRefresh = false,
  }) async {
    // Create cache key based on location
    final cacheKey = 'weather_advisory_${city}_${state}_$country';

    // Try to get from cache first (unless force refresh)
    if (!forceRefresh) {
      final cachedData = await _cache.getFromCache(cacheKey);
      if (cachedData != null) {
        print('📦 Using cached weather data for $city');
        return cachedData as Map<String, dynamic>;
      }
    }

    http.Client? client;
    try {
      client = http.Client();

      print('=== WEATHER ADVISORY: Fetching data ===');
      print('City: $city');
      print('State: $state');
      print('Country: $country');

      final response = await client
          .post(
            Uri.parse(backendUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'city': city,
              'state': state,
              'country': country,
            }),
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

        // Validate required fields
        if (!data.containsKey('location') ||
            !data.containsKey('forecast') ||
            !data.containsKey('advisory')) {
          throw Exception('Response missing required fields');
        }

        print('Successfully fetched weather advisory');

        // Save to cache
        await _cache.saveToCache(cacheKey, data);

        return data;
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Bad request');
      } else if (response.statusCode == 500) {
        final errorData = json.decode(response.body);
        throw Exception(
          'Server error: ${errorData['detail'] ?? "Unknown error"}',
        );
      } else if (response.statusCode == 502) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Weather data not available');
      } else {
        throw Exception(
          'Failed to fetch weather advisory: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching weather advisory: $e');
      throw Exception('Failed to fetch weather advisory: $e');
    } finally {
      client?.close();
    }
  }

  /// Clear weather cache for a specific location
  static Future<void> clearWeatherCache(
    String city,
    String state,
    String country,
  ) async {
    final cacheKey = 'weather_advisory_${city}_${state}_$country';
    await _cache.clearCache(cacheKey);
  }
}

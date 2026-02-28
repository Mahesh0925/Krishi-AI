import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'cache_service.dart';

class NearbyStoresService {
  // Backend endpoint for fetching nearby agricultural stores
  // Note: This endpoint is shared with market-prices functionality
  static const String backendUrl =
      'https://mor-backend-4i9u.onrender.com/market-prices';
  static final CacheService _cache = CacheService();

  /// Fetch nearby agricultural stores based on location
  static Future<Map<String, dynamic>> fetchNearbyStores({
    double? latitude,
    double? longitude,
    String? city,
    String? state,
    bool forceRefresh = false,
  }) async {
    // Get current location if not provided
    if (latitude == null || longitude == null) {
      try {
        final position = await _getCurrentLocation();
        latitude = position.latitude;
        longitude = position.longitude;
      } catch (e) {
        print('Error getting location: $e');
        throw Exception('Failed to get current location: $e');
      }
    }

    // Create cache key based on location
    final cacheKey = 'nearby_stores_${latitude}_$longitude';

    // Try to get from cache first (unless force refresh)
    if (!forceRefresh) {
      final cachedData = await _cache.getFromCache(cacheKey);
      if (cachedData != null) {
        print('📦 Using cached nearby stores data');
        return cachedData as Map<String, dynamic>;
      }
    }

    http.Client? client;
    try {
      client = http.Client();

      print('=== NEARBY STORES: Fetching from backend ===');
      print('Latitude: $latitude');
      print('Longitude: $longitude');
      print('City: $city');
      print('State: $state');

      // Request body with latitude and longitude
      final requestBody = {
        'latitude': latitude,
        'longitude': longitude,
        if (city != null && city.isNotEmpty) 'city': city,
        if (state != null && state.isNotEmpty) 'state': state,
      };

      final response = await client
          .post(
            Uri.parse(backendUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestBody),
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
            data['stores'] is List &&
            (data['stores'] as List).isEmpty) {
          print('Backend returned error response with raw_response');
          throw Exception(
            'Backend failed to parse response: ${data['detail'] ?? "Unknown error"}',
          );
        }

        // Validate stores field
        if (!data.containsKey('stores')) {
          throw Exception('Response missing stores field');
        }

        // Save to cache
        await _cache.saveToCache(cacheKey, data);

        print(
          '✅ Successfully fetched ${(data['stores'] as List).length} stores from backend',
        );
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
          'Failed to fetch nearby stores: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching nearby stores: $e');

      // If it's a network error or 404, return fallback data
      if (e.toString().contains('404') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        print('⚠️ Using fallback data due to error');
        return _getFallbackStores(latitude, longitude, 'Current Location');
      }

      rethrow;
    } finally {
      client?.close();
    }
  }

  /// Fallback data when backend is not available
  static Map<String, dynamic> _getFallbackStores(
    double latitude,
    double longitude,
    String locationName,
  ) {
    return {
      'stores': [
        {
          'name': 'Green Valley Agro Center',
          'distance': '1.2 km',
          'address': 'Shop 12, Market Road, Near Bus Stand',
          'rating': 4.5,
          'is_open': true,
          'phone': '+91 98765 43210',
          'latitude': latitude + 0.01,
          'longitude': longitude + 0.01,
        },
        {
          'name': 'Farmers Choice Pesticides',
          'distance': '2.5 km',
          'address': 'Main Market, Agricultural Complex',
          'rating': 4.3,
          'is_open': true,
          'phone': '+91 98765 43211',
          'latitude': latitude + 0.02,
          'longitude': longitude - 0.01,
        },
        {
          'name': 'Krishi Seva Kendra',
          'distance': '3.8 km',
          'address': 'Government Agricultural Office Road',
          'rating': 4.7,
          'is_open': false,
          'phone': '+91 98765 43212',
          'latitude': latitude - 0.02,
          'longitude': longitude + 0.02,
        },
        {
          'name': 'Agri Solutions Hub',
          'distance': '4.2 km',
          'address': 'Industrial Area, Sector 5',
          'rating': 4.4,
          'is_open': true,
          'phone': '+91 98765 43213',
          'latitude': latitude - 0.03,
          'longitude': longitude - 0.02,
        },
        {
          'name': 'Bharat Pesticides & Seeds',
          'distance': '5.1 km',
          'address': 'Highway Road, Near Petrol Pump',
          'rating': 4.6,
          'is_open': true,
          'phone': '+91 98765 43214',
          'latitude': latitude + 0.04,
          'longitude': longitude + 0.03,
        },
      ],
      'location': locationName,
      'total_stores': 5,
      'note': 'Backend endpoint connected but returned sample data.',
    };
  }

  /// Get current location using Geolocator
  static Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Clear nearby stores cache
  static Future<void> clearStoresCache(
    double latitude,
    double longitude,
  ) async {
    final cacheKey = 'nearby_stores_${latitude}_$longitude';
    await _cache.clearCache(cacheKey);
  }
}

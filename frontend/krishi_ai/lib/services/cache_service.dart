import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  // In-memory cache for current session
  final Map<String, CachedData> _memoryCache = {};

  // Cache duration (30 minutes)
  static const Duration cacheDuration = Duration(minutes: 30);

  /// Save data to cache (both memory and persistent storage)
  Future<void> saveToCache(String key, dynamic data) async {
    try {
      final cachedData = CachedData(data: data, timestamp: DateTime.now());

      // Save to memory cache
      _memoryCache[key] = cachedData;

      // Save to persistent storage
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode({
        'data': data,
        'timestamp': cachedData.timestamp.toIso8601String(),
      });
      await prefs.setString(key, jsonString);

      print('✅ Cached data for key: $key');
    } catch (e) {
      print('❌ Error saving to cache: $e');
    }
  }

  /// Get data from cache (checks memory first, then persistent storage)
  Future<dynamic> getFromCache(String key) async {
    try {
      // Check memory cache first
      if (_memoryCache.containsKey(key)) {
        final cachedData = _memoryCache[key]!;
        if (_isCacheValid(cachedData.timestamp)) {
          print('✅ Retrieved from memory cache: $key');
          return cachedData.data;
        } else {
          // Remove expired cache
          _memoryCache.remove(key);
          print('⏰ Memory cache expired for: $key');
        }
      }

      // Check persistent storage
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(key);

      if (jsonString != null) {
        final jsonData = jsonDecode(jsonString);
        final timestamp = DateTime.parse(jsonData['timestamp']);

        if (_isCacheValid(timestamp)) {
          final data = jsonData['data'];
          // Restore to memory cache
          _memoryCache[key] = CachedData(data: data, timestamp: timestamp);
          print('✅ Retrieved from persistent cache: $key');
          return data;
        } else {
          // Remove expired cache
          await prefs.remove(key);
          print('⏰ Persistent cache expired for: $key');
        }
      }

      print('❌ No valid cache found for: $key');
      return null;
    } catch (e) {
      print('❌ Error getting from cache: $e');
      return null;
    }
  }

  /// Check if cache is still valid
  bool _isCacheValid(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference < cacheDuration;
  }

  /// Clear specific cache entry
  Future<void> clearCache(String key) async {
    try {
      _memoryCache.remove(key);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      print('🗑️ Cleared cache for: $key');
    } catch (e) {
      print('❌ Error clearing cache: $e');
    }
  }

  /// Clear all cache
  Future<void> clearAllCache() async {
    try {
      _memoryCache.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('🗑️ Cleared all cache');
    } catch (e) {
      print('❌ Error clearing all cache: $e');
    }
  }

  /// Get cache age in minutes
  Future<int?> getCacheAge(String key) async {
    try {
      if (_memoryCache.containsKey(key)) {
        final difference = DateTime.now().difference(
          _memoryCache[key]!.timestamp,
        );
        return difference.inMinutes;
      }

      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final jsonData = jsonDecode(jsonString);
        final timestamp = DateTime.parse(jsonData['timestamp']);
        final difference = DateTime.now().difference(timestamp);
        return difference.inMinutes;
      }
    } catch (e) {
      print('❌ Error getting cache age: $e');
    }
    return null;
  }
}

class CachedData {
  final dynamic data;
  final DateTime timestamp;

  CachedData({required this.data, required this.timestamp});
}

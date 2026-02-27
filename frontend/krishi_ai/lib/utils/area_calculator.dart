import 'dart:math';
import 'package:latlong2/latlong.dart';

/// Utility class for calculating geographic areas
class AreaCalculator {
  /// Earth's radius in meters
  static const double earthRadius = 6371000.0;

  /// Converts square meters to acres
  /// 1 acre = 4046.86 square meters
  static double squareMetersToAcres(double squareMeters) {
    return squareMeters / 4046.86;
  }

  /// Calculates the area of a polygon using the Shoelace formula
  /// with Haversine distance for geodesic accuracy
  /// 
  /// [points] - List of LatLng coordinates forming the polygon
  /// Returns area in square meters
  static double calculatePolygonArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    // Convert lat/lng to radians and calculate area using spherical excess
    double area = 0.0;
    
    for (int i = 0; i < points.length; i++) {
      int j = (i + 1) % points.length;
      
      double lat1 = _toRadians(points[i].latitude);
      double lon1 = _toRadians(points[i].longitude);
      double lat2 = _toRadians(points[j].latitude);
      double lon2 = _toRadians(points[j].longitude);
      
      area += (lon2 - lon1) * (2 + sin(lat1) + sin(lat2));
    }
    
    area = area.abs() * earthRadius * earthRadius / 2.0;
    
    return area;
  }

  /// Converts degrees to radians
  static double _toRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  /// Calculates distance between two points using Haversine formula
  /// Returns distance in meters
  static double calculateDistance(LatLng point1, LatLng point2) {
    double lat1 = _toRadians(point1.latitude);
    double lat2 = _toRadians(point2.latitude);
    double deltaLat = _toRadians(point2.latitude - point1.latitude);
    double deltaLon = _toRadians(point2.longitude - point1.longitude);

    double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Formats area value for display
  /// Shows 2 decimal places for values >= 0.01 acres
  /// Shows 4 decimal places for smaller values
  static String formatArea(double acres) {
    if (acres >= 0.01) {
      return acres.toStringAsFixed(2);
    } else {
      return acres.toStringAsFixed(4);
    }
  }
}

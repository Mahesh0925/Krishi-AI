import 'package:latlong2/latlong.dart';

/// Model class representing a point on the map
class MapPoint {
  final LatLng coordinates;
  final int index;
  final DateTime timestamp;

  MapPoint({
    required this.coordinates,
    required this.index,
    required this.timestamp,
  });

  /// Creates a copy of this MapPoint with optional parameter overrides
  MapPoint copyWith({
    LatLng? coordinates,
    int? index,
    DateTime? timestamp,
  }) {
    return MapPoint(
      coordinates: coordinates ?? this.coordinates,
      index: index ?? this.index,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapPoint &&
        other.coordinates == coordinates &&
        other.index == index;
  }

  @override
  int get hashCode => coordinates.hashCode ^ index.hashCode;
}

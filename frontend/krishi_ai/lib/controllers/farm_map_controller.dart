import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../models/map_point.dart';
import '../utils/area_calculator.dart';

/// Controller managing the farm area measurement logic
class FarmMapController extends GetxController {
  // Observable list of selected points
  final RxList<MapPoint> selectedPoints = <MapPoint>[].obs;
  
  // Observable for calculated area in acres
  final RxDouble areaInAcres = 0.0.obs;
  
  // Observable for map type (satellite/normal)
  final RxBool isSatelliteView = false.obs;
  
  // Observable for map center position
  final Rx<LatLng> mapCenter = LatLng(20.5937, 78.9629).obs; // India center
  
  // Observable for map zoom level
  final RxDouble mapZoom = 5.0.obs;

  /// Adds a new point to the polygon
  void addPoint(LatLng coordinates) {
    final newPoint = MapPoint(
      coordinates: coordinates,
      index: selectedPoints.length,
      timestamp: DateTime.now(),
    );
    
    selectedPoints.add(newPoint);
    _calculateArea();
  }

  /// Removes the last added point
  void undoLastPoint() {
    if (selectedPoints.isNotEmpty) {
      selectedPoints.removeLast();
      _calculateArea();
    }
  }

  /// Clears all selected points and resets the area
  void clearAllPoints() {
    selectedPoints.clear();
    areaInAcres.value = 0.0;
  }

  /// Toggles between satellite and normal map view
  void toggleMapType() {
    isSatelliteView.value = !isSatelliteView.value;
  }

  /// Updates map center position
  void updateMapCenter(LatLng center) {
    mapCenter.value = center;
  }

  /// Updates map zoom level
  void updateMapZoom(double zoom) {
    mapZoom.value = zoom;
  }

  /// Calculates the area of the polygon formed by selected points
  void _calculateArea() {
    if (selectedPoints.length < 3) {
      areaInAcres.value = 0.0;
      return;
    }

    final coordinates = selectedPoints.map((point) => point.coordinates).toList();
    final areaInSquareMeters = AreaCalculator.calculatePolygonArea(coordinates);
    areaInAcres.value = AreaCalculator.squareMetersToAcres(areaInSquareMeters);
  }

  /// Gets the list of coordinates for drawing the polygon
  List<LatLng> get polygonCoordinates {
    return selectedPoints.map((point) => point.coordinates).toList();
  }

  /// Checks if area calculation is valid (minimum 3 points required)
  bool get isAreaValid {
    return selectedPoints.length >= 3;
  }

  /// Gets formatted area string for display
  String get formattedArea {
    if (!isAreaValid) return '0.00';
    return AreaCalculator.formatArea(areaInAcres.value);
  }

  /// Gets the count of selected points
  int get pointCount {
    return selectedPoints.length;
  }
}

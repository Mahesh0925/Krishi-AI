import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/farm_map_controller.dart';

/// Main screen for farm area measurement using OpenStreetMap
class FarmMapScreen extends StatelessWidget {
  FarmMapScreen({super.key});

  final FarmMapController controller = Get.put(FarmMapController());
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Measure Farm Area',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Map type toggle button
          Obx(() => IconButton(
                icon: Icon(
                  controller.isSatelliteView.value
                      ? Icons.map
                      : Icons.satellite_alt,
                ),
                tooltip: controller.isSatelliteView.value
                    ? 'Normal View'
                    : 'Satellite View',
                onPressed: controller.toggleMapType,
              )),
        ],
      ),
      body: Stack(
        children: [
          // Map widget
          Obx(() => FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: controller.mapCenter.value,
                  initialZoom: controller.mapZoom.value,
                  onTap: (tapPosition, point) {
                    controller.addPoint(point);
                  },
                  onPositionChanged: (position, hasGesture) {
                    if (hasGesture) {
                      controller.updateMapCenter(position.center);
                    }
                    if (hasGesture) {
                      controller.updateMapZoom(position.zoom);
                    }
                  },
                ),
                children: [
                  // Tile layer - switches between normal and satellite view
                  TileLayer(
                    urlTemplate: controller.isSatelliteView.value
                        ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.krishi_ai',
                    maxZoom: 19,
                  ),
                  
                  // Polygon layer - draws the farm boundary
                  if (controller.selectedPoints.length >= 2)
                    PolygonLayer(
                      polygons: [
                        Polygon(
                          points: controller.polygonCoordinates,
                          color: const Color(0xFF4CAF50).withOpacity(0.3),
                          borderColor: const Color(0xFF2E7D32),
                          borderStrokeWidth: 3.0,
                          isFilled: true,
                        ),
                      ],
                    ),
                  
                  // Marker layer - shows selected points
                  MarkerLayer(
                    markers: controller.selectedPoints.map((point) {
                      return Marker(
                        point: point.coordinates,
                        width: 40,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${point.index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )),

          // Control buttons panel
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                // Undo button
                _buildControlButton(
                  icon: Icons.undo,
                  tooltip: 'Undo Last Point',
                  onPressed: () {
                    if (controller.selectedPoints.isNotEmpty) {
                      controller.undoLastPoint();
                    }
                  },
                ),
                const SizedBox(height: 8),
                
                // Clear all button
                _buildControlButton(
                  icon: Icons.delete_outline,
                  tooltip: 'Clear All Points',
                  onPressed: () {
                    if (controller.selectedPoints.isNotEmpty) {
                      _showClearConfirmation(context);
                    }
                  },
                ),
              ],
            ),
          ),

          // Bottom information card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() => _buildInfoCard()),
          ),
        ],
      ),
    );
  }

  /// Builds a control button with consistent styling
  Widget _buildControlButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF2E7D32)),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }

  /// Builds the bottom information card showing area and point count
  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Instructions or area display
          if (!controller.isAreaValid)
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tap on the map to mark farm boundary points (minimum 3 points required)',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                // Area display
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.landscape,
                      color: Color(0xFF2E7D32),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Farm Area',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${controller.formattedArea} acres',
                          style: const TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
              ],
            ),
          
          // Point count
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${controller.pointCount} ${controller.pointCount == 1 ? 'point' : 'points'} marked',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Shows confirmation dialog before clearing all points
  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Points?'),
        content: const Text(
          'This will remove all marked points and reset the area calculation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.clearAllPoints();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

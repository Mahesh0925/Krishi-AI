import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LandMeasureScreen extends StatefulWidget {
  const LandMeasureScreen({super.key});

  @override
  State<LandMeasureScreen> createState() => _LandMeasureScreenState();
}

class _LandMeasureScreenState extends State<LandMeasureScreen> {
  final MapController _mapController = MapController();
  final List<LatLng> _points = [];
  final List<Marker> _markers = [];

  LatLng? _currentPosition;
  double _areaInSquareMeters = 0.0;
  bool _isLoading = true;
  bool _isSatelliteView = true; // Default to satellite view

  static const Color primary = Color(0xFF59F20D);
  static const Color backgroundDark = Color(0xFF0A0F08);
  static const Color surfaceDark = Color(0xFF162210);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          _showError('Location services are disabled. Please enable them.');
          setState(() => _isLoading = false);
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            _showError('Location permission denied');
            setState(() => _isLoading = false);
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          _showPermissionDialog();
          setState(() => _isLoading = false);
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });

        // Move map after a short delay to ensure widget is rendered
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            try {
              _mapController.move(_currentPosition!, 16.0);
            } catch (e) {
              print('Error moving map: $e');
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        _showError('Error getting location: ${e.toString()}');
        setState(() => _isLoading = false);
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceDark,
        title: Text(
          'Location Permission Required',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'This app needs location permission to measure land area. Please enable it in app settings.',
          style: GoogleFonts.spaceGrotesk(color: Colors.grey[400]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.spaceGrotesk(color: Colors.grey[400]),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openAppSettings();
            },
            child: Text(
              'Open Settings',
              style: GoogleFonts.spaceGrotesk(color: primary),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapTapped(TapPosition tapPosition, LatLng position) {
    if (_points.length >= 10) {
      _showError('Maximum 10 points allowed. Please reset to start over.');
      return;
    }

    setState(() {
      _points.add(position);
      _addMarker(position, _points.length);

      if (_points.length >= 3) {
        _calculateArea();
      }
    });
  }

  void _addMarker(LatLng position, int index) {
    final marker = Marker(
      point: position,
      width: 40,
      height: 40,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              '$index',
              style: GoogleFonts.spaceGrotesk(
                color: backgroundDark,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    _markers.add(marker);
  }

  void _calculateArea() {
    if (_points.length < 3) {
      setState(() => _areaInSquareMeters = 0.0);
      return;
    }

    try {
      const double earthRadius = 6378137.0;
      double area = 0.0;

      if (_points.length == 3) {
        final a = _calculateDistance(_points[0], _points[1]);
        final b = _calculateDistance(_points[1], _points[2]);
        final c = _calculateDistance(_points[2], _points[0]);

        final s = (a + b + c) / 2;
        area = math.sqrt(s * (s - a) * (s - b) * (s - c));
      } else {
        for (int i = 0; i < _points.length; i++) {
          final p1 = _points[i];
          final p2 = _points[(i + 1) % _points.length];

          final lat1 = _toRadians(p1.latitude);
          final lat2 = _toRadians(p2.latitude);
          final lng1 = _toRadians(p1.longitude);
          final lng2 = _toRadians(p2.longitude);

          area += (lng2 - lng1) * (2 + math.sin(lat1) + math.sin(lat2));
        }

        area = (area * earthRadius * earthRadius / 2).abs();
      }

      setState(() {
        _areaInSquareMeters = area;
      });
    } catch (e) {
      _showError('Error calculating area: $e');
    }
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6378137.0;

    final lat1 = _toRadians(point1.latitude);
    final lat2 = _toRadians(point2.latitude);
    final dLat = _toRadians(point2.latitude - point1.latitude);
    final dLng = _toRadians(point2.longitude - point1.longitude);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }

  void _resetPoints() {
    setState(() {
      _points.clear();
      _markers.clear();
      _areaInSquareMeters = 0.0;
    });
  }

  void _undoLastPoint() {
    if (_points.isEmpty) return;

    setState(() {
      _points.removeLast();
      _markers.removeLast();

      if (_points.length >= 3) {
        _calculateArea();
      } else {
        _areaInSquareMeters = 0.0;
      }
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.spaceGrotesk()),
        backgroundColor: Colors.red,
      ),
    );
  }

  double _convertToAcres(double squareMeters) {
    return squareMeters / 4046.86;
  }

  double _convertToHectares(double squareMeters) {
    return squareMeters / 10000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: surfaceDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Measure Land Area',
          style: GoogleFonts.spaceGrotesk(
            color: primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Map Type Toggle Button
          IconButton(
            icon: Icon(
              _isSatelliteView ? Icons.map : Icons.satellite,
              color: primary,
            ),
            tooltip: _isSatelliteView ? 'Street View' : 'Satellite View',
            onPressed: () {
              setState(() {
                _isSatelliteView = !_isSatelliteView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.my_location, color: primary),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Flutter Map
          _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: primary),
                      const SizedBox(height: 16),
                      Text(
                        'Getting your location...',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter:
                        _currentPosition ?? const LatLng(20.5937, 78.9629),
                    initialZoom: _currentPosition != null ? 16.0 : 5.0,
                    onTap: _onMapTapped,
                    onMapReady: () {
                      // Map is ready, safe to use controller now
                      if (_currentPosition != null) {
                        try {
                          _mapController.move(_currentPosition!, 16.0);
                        } catch (e) {
                          print('Error moving map on ready: $e');
                        }
                      }
                    },
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    // Base Map Layer - Satellite or Street
                    TileLayer(
                      urlTemplate: _isSatelliteView
                          ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                          : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.krishi_ai',
                    ),
                    // Labels overlay for satellite view
                    if (_isSatelliteView)
                      TileLayer(
                        urlTemplate:
                            'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}',
                        userAgentPackageName: 'com.example.krishi_ai',
                      ),
                    // Polygon Layer
                    if (_points.length >= 3)
                      PolygonLayer(
                        polygons: [
                          Polygon(
                            points: _points,
                            color: primary.withValues(alpha: 0.2),
                            borderColor: primary,
                            borderStrokeWidth: 3,
                            isFilled: true,
                          ),
                        ],
                      ),
                    // Markers Layer
                    MarkerLayer(markers: _markers),
                    // Current Location Marker
                    if (_currentPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentPosition!,
                            width: 20,
                            height: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

          // Instructions Card
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceDark.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primary.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.touch_app,
                          color: primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tap corners of your land',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Minimum 3 points required',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.grey[400],
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Points marked:',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_points.length}',
                            style: GoogleFonts.spaceGrotesk(
                              color: backgroundDark,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Area Display Card
          if (_areaInSquareMeters > 0)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [surfaceDark, surfaceDark.withValues(alpha: 0.9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.square_foot, color: primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Measured Area',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAreaUnit(
                          'Sq. Meters',
                          _areaInSquareMeters.toStringAsFixed(2),
                          'm²',
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        _buildAreaUnit(
                          'Acres',
                          _convertToAcres(
                            _areaInSquareMeters,
                          ).toStringAsFixed(3),
                          'ac',
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        _buildAreaUnit(
                          'Hectares',
                          _convertToHectares(
                            _areaInSquareMeters,
                          ).toStringAsFixed(3),
                          'ha',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Map Type Floating Button
          Positioned(
            right: 16,
            top: 200,
            child: Container(
              decoration: BoxDecoration(
                color: surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primary.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMapTypeButton(
                    icon: Icons.satellite,
                    label: 'Satellite',
                    isSelected: _isSatelliteView,
                    onTap: () {
                      setState(() {
                        _isSatelliteView = true;
                      });
                    },
                  ),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  _buildMapTypeButton(
                    icon: Icons.map,
                    label: 'Street',
                    isSelected: !_isSatelliteView,
                    onTap: () {
                      setState(() {
                        _isSatelliteView = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom Buttons Row
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Undo Button
                FloatingActionButton(
                  onPressed: _points.isEmpty ? null : _undoLastPoint,
                  backgroundColor: _points.isEmpty ? Colors.grey[800] : primary,
                  foregroundColor: backgroundDark,
                  child: const Icon(Icons.undo),
                ),
                const SizedBox(width: 12),
                // Reset Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _points.isEmpty ? null : _resetPoints,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Points'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: backgroundDark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey[800],
                      disabledForegroundColor: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapTypeButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? primary : Colors.grey[400],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: isSelected ? primary : Colors.grey[400],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaUnit(String label, String value, String unit) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              color: primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            unit,
            style: GoogleFonts.spaceGrotesk(
              color: primary.withValues(alpha: 0.7),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.grey[500],
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../services/weather_advisory_service.dart';

class WeatherAdvisoryScreen extends StatefulWidget {
  const WeatherAdvisoryScreen({super.key});

  @override
  State<WeatherAdvisoryScreen> createState() => _WeatherAdvisoryScreenState();
}

class _WeatherAdvisoryScreenState extends State<WeatherAdvisoryScreen> {
  final Color primary = const Color(0xFF2E7D32);

  bool _isLoading = false;
  Map<String, dynamic>? _weatherData;
  String? _errorMessage;
  String? _currentCity;
  String? _currentState;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocationAndWeather();
  }

  Future<void> _fetchCurrentLocationAndWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _weatherData = null;
    });

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied. Please enable them in settings.',
        );
      }

      // Get current position
      print('Getting current position...');
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('Position: ${position.latitude}, ${position.longitude}');

      // Get address from coordinates
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        throw Exception('Could not determine location');
      }

      final Placemark place = placemarks[0];
      final city = place.locality ?? place.subAdministrativeArea ?? 'Unknown';
      final state = place.administrativeArea ?? '';

      print('Location: $city, $state');

      setState(() {
        _currentCity = city;
        _currentState = state;
      });

      // Fetch weather advisory
      await _fetchWeatherAdvisory(city, state);
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherAdvisory(String city, String state) async {
    try {
      final result = await WeatherAdvisoryService.fetchWeatherAdvisory(
        city: city,
        state: state,
      );

      setState(() {
        _weatherData = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Weather & Crop Advisory",
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isLoading ? null : _fetchCurrentLocationAndWeather,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: primary),
            const SizedBox(height: 16),
            Text(
              _currentCity != null
                  ? 'Fetching weather for $_currentCity...'
                  : 'Getting your location...',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    if (_weatherData != null) {
      return SingleChildScrollView(child: _buildWeatherContent());
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              "Error",
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchCurrentLocationAndWeather,
              icon: const Icon(Icons.refresh),
              label: Text('Retry', style: GoogleFonts.spaceGrotesk()),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    final location = _weatherData!['location'] as Map<String, dynamic>?;
    final forecast = _weatherData!['forecast'] as List<dynamic>?;
    final advisory = _weatherData!['advisory'] as Map<String, dynamic>?;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Info
          if (location != null) _buildLocationCard(location),
          const SizedBox(height: 16),

          // Weather Summary
          if (advisory?['weather_summary'] != null)
            _buildSummaryCard(advisory!['weather_summary']),
          const SizedBox(height: 16),

          // Forecast
          if (forecast != null && forecast.isNotEmpty)
            _buildForecastSection(forecast),
          const SizedBox(height: 16),

          // Recommended Crops
          if (advisory?['recommended_crops'] != null)
            _buildRecommendedCrops(advisory!['recommended_crops']),
          const SizedBox(height: 16),

          // Farm Actions
          if (advisory?['farm_actions'] != null)
            _buildActionsList(
              "Farm Actions",
              advisory!['farm_actions'],
              Icons.agriculture,
            ),
          const SizedBox(height: 16),

          // Risk Alerts
          if (advisory?['risk_alerts'] != null &&
              (advisory!['risk_alerts'] as List).isNotEmpty)
            _buildActionsList(
              "Risk Alerts",
              advisory['risk_alerts'],
              Icons.warning,
              isAlert: true,
            ),
          const SizedBox(height: 16),

          // Other Suggestions
          if (advisory?['other_suggestions'] != null)
            _buildActionsList(
              "Other Suggestions",
              advisory!['other_suggestions'],
              Icons.lightbulb,
            ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(Map<String, dynamic> location) {
    return Card(
      color: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.location_on, color: primary, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location['city'] ?? 'Unknown',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${location['state'] ?? ''}, ${location['country'] ?? ''}',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String summary) {
    return Card(
      color: primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.wb_sunny, color: primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  "Weather Summary",
                  style: GoogleFonts.spaceGrotesk(
                    color: primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              summary,
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastSection(List<dynamic> forecast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "5-Day Forecast",
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.length,
            itemBuilder: (context, index) {
              final day = forecast[index] as Map<String, dynamic>;
              return _buildForecastCard(day);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCard(Map<String, dynamic> day) {
    return Card(
      color: const Color(0xFF2A2A2A),
      margin: const EdgeInsets.only(right: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day['date'] ?? '',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Icon(_getWeatherIcon(day['condition']), color: primary, size: 32),
            const SizedBox(height: 8),
            Text(
              '${day['temp_max_c']}°/${day['temp_min_c']}°',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            if (day['rain_mm_total'] > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.water_drop, size: 12, color: Colors.blue[300]),
                  const SizedBox(width: 2),
                  Text(
                    '${day['rain_mm_total']}mm',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.blue[300],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String? condition) {
    final cond = (condition ?? '').toLowerCase();
    if (cond.contains('rain') || cond.contains('drizzle')) {
      return Icons.water_drop;
    } else if (cond.contains('cloud')) {
      return Icons.cloud;
    } else if (cond.contains('sun') || cond.contains('clear')) {
      return Icons.wb_sunny;
    } else if (cond.contains('storm') || cond.contains('thunder')) {
      return Icons.thunderstorm;
    }
    return Icons.wb_cloudy;
  }

  Widget _buildRecommendedCrops(List<dynamic> crops) {
    if (crops.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recommended Crops",
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...crops.map((crop) => _buildCropCard(crop as Map<String, dynamic>)),
      ],
    );
  }

  Widget _buildCropCard(Map<String, dynamic> crop) {
    final suitability = crop['suitability'] ?? 'medium';
    Color suitabilityColor = Colors.orange;
    if (suitability == 'high') {
      suitabilityColor = Colors.green;
    } else if (suitability == 'low') {
      suitabilityColor = Colors.red;
    }

    return Card(
      color: const Color(0xFF2A2A2A),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.eco, color: primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    crop['crop'] ?? 'Unknown',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: suitabilityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: suitabilityColor),
                  ),
                  child: Text(
                    suitability.toUpperCase(),
                    style: GoogleFonts.spaceGrotesk(
                      color: suitabilityColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (crop['reason'] != null) ...[
              const SizedBox(height: 8),
              Text(
                crop['reason'],
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.grey[400],
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionsList(
    String title,
    List<dynamic> actions,
    IconData icon, {
    bool isAlert = false,
  }) {
    if (actions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: isAlert
              ? Colors.red.withOpacity(0.1)
              : const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isAlert
                ? BorderSide(color: Colors.red.withOpacity(0.3))
                : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: actions.map((action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        icon,
                        size: 20,
                        color: isAlert ? Colors.red[300] : primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          action.toString(),
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

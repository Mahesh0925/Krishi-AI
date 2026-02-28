import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:krishi_ai/View/bottom_nav_bar.dart';
import 'package:krishi_ai/View/camera_screen.dart';
import 'package:krishi_ai/View/gov_schemes_screen.dart';
import 'package:krishi_ai/View/market_screen.dart';
import 'package:krishi_ai/View/weather_advisory_screen.dart';
import 'package:krishi_ai/widgets/chatbot_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../services/weather_advisory_service.dart';

class KrishiAIDashboard extends StatefulWidget {
  const KrishiAIDashboard({super.key});

  @override
  State<KrishiAIDashboard> createState() => _KrishiAIDashboardState();
}

class _KrishiAIDashboardState extends State<KrishiAIDashboard> {
  int selectedIndex = 0;
  DateTime? lastPressedTime;

  // GlobalKeys for tutorial
  final GlobalKey scanDiseaseKey = GlobalKey();
  final GlobalKey weatherKey = GlobalKey();
  final GlobalKey mandiPricesKey = GlobalKey();
  final GlobalKey schemesKey = GlobalKey();

  // Tutorial coach mark
  TutorialCoachMark? tutorialCoachMark;

  // Scroll controller for tutorial
  final ScrollController _scrollController = ScrollController();
  bool _waitingForScroll = false;

  // Weather data
  bool _isLoadingWeather = true;
  Map<String, dynamic>? _weatherData;
  String _locationName = "Loading...";
  String _temperature = "--";
  String _condition = "Loading weather...";
  String _humidity = "--";
  String _windSpeed = "--";
  String _rainChance = "--";
  IconData _weatherIcon = Icons.wb_cloudy;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
    _checkAndShowTutorial();

    // Listen to scroll events for tutorial
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Handle scroll events for tutorial
  void _onScroll() {
    if (_waitingForScroll && _isSchemeButtonVisible()) {
      _waitingForScroll = false;
      // Show schemes tutorial after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _showSchemesTutorial();
        }
      });
    }
  }

  // Check if schemes button is visible on screen
  bool _isSchemeButtonVisible() {
    final RenderBox? renderBox =
        schemesKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return false;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenHeight = MediaQuery.of(context).size.height;

    // Check if at least 50% of the button is visible
    return position.dy + size.height / 2 < screenHeight && position.dy > 0;
  }

  // Check if tutorial should be shown
  Future<void> _checkAndShowTutorial() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tutorialSeen = prefs.getBool('tutorialSeen') ?? false;

      print('🎓 Tutorial check: tutorialSeen = $tutorialSeen');

      if (!tutorialSeen) {
        print('🎓 Tutorial will be shown after delay');
        // Show tutorial after the first frame is rendered
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              print('🎓 Showing tutorial now');
              _showTutorial();
            }
          });
        });
      } else {
        print('🎓 Tutorial already seen, skipping');
      }
    } catch (e) {
      print('🎓 Error checking tutorial: $e');
    }
  }

  // Create tutorial targets
  void _createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('tutorialSeen', true);
      },
      onSkip: () {
        _saveTutorialSeen();
        return true;
      },
    );
  }

  // Save tutorial seen status
  Future<void> _saveTutorialSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorialSeen', true);
  }

  // Create target focuses for tutorial
  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    // Target 1: Scan Disease Button (Top-Left)
    targets.add(
      TargetFocus(
        identify: "scanDiseaseKey",
        keyTarget: scanDiseaseKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            builder: (context, controller) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 280),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2923),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF59F20D), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "tutorial_scan_title".tr,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF59F20D),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "tutorial_scan_desc".tr,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            controller.skip();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "tutorial_skip".tr,
                            style: GoogleFonts.inter(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.next();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF59F20D),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "tutorial_next".tr,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    // Target 2: Weather Button
    targets.add(
      TargetFocus(
        identify: "weatherKey",
        keyTarget: weatherKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            builder: (context, controller) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 280),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2923),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF59F20D), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "tutorial_weather_title".tr,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF59F20D),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "tutorial_weather_desc".tr,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            controller.skip();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "tutorial_skip".tr,
                            style: GoogleFonts.inter(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.next();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF59F20D),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "tutorial_next".tr,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    // Target 3: Mandi Prices Button with scroll hint
    targets.add(
      TargetFocus(
        identify: "mandiPricesKey",
        keyTarget: mandiPricesKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            builder: (context, controller) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2923),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF59F20D), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "tutorial_mandi_title".tr,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF59F20D),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "tutorial_mandi_desc".tr,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Scroll hint section
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF59F20D).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF59F20D).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_downward,
                            color: Color(0xFF59F20D),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "tutorial_scroll_hint".tr,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF59F20D),
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            controller.skip();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "tutorial_skip".tr,
                            style: GoogleFonts.inter(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _waitingForScroll = true;
                            controller.next();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF59F20D),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "tutorial_next".tr,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }

  // Show schemes tutorial separately
  void _showSchemesTutorial() {
    final schemesTutorial = TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: "schemesKey",
          keyTarget: schemesKey,
          alignSkip: Alignment.topRight,
          shape: ShapeLightFocus.RRect,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              builder: (context, controller) {
                return Container(
                  constraints: const BoxConstraints(maxWidth: 280),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2923),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF59F20D),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "tutorial_schemes_title".tr,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF59F20D),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "tutorial_schemes_desc".tr,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              controller.next();
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('tutorialSeen', true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF59F20D),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              "tutorial_got_it".tr,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('tutorialSeen', true);
      },
      onSkip: () {
        _saveTutorialSeen();
        return true;
      },
    );

    schemesTutorial.show(context: context);
  }

  // Show tutorial
  void _showTutorial() {
    try {
      print('🎓 Creating tutorial...');
      _createTutorial();
      print('🎓 Tutorial created, showing now...');
      tutorialCoachMark?.show(context: context);
      print('🎓 Tutorial show() called');
    } catch (e) {
      print('🎓 Error showing tutorial: $e');
    }
  }

  Future<void> _fetchWeatherData() async {
    try {
      // Get location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoadingWeather = false;
          _locationName = "Location Unavailable";
          _condition = "Enable location to see weather";
        });
        return;
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        final city = place.locality ?? place.subAdministrativeArea ?? 'Unknown';
        final state = place.administrativeArea ?? '';

        // Fetch weather data
        final weatherData = await WeatherAdvisoryService.fetchWeatherAdvisory(
          city: city,
          state: state,
        );

        if (mounted) {
          setState(() {
            _weatherData = weatherData;
            _isLoadingWeather = false;

            // Extract location
            final location = weatherData['location'] as Map<String, dynamic>?;
            _locationName =
                '${location?['city'] ?? city}, ${location?['country'] ?? 'India'}';

            // Extract current weather from first forecast day
            final forecast = weatherData['forecast'] as List<dynamic>?;
            if (forecast != null && forecast.isNotEmpty) {
              final today = forecast[0] as Map<String, dynamic>;
              _temperature = '${today['temp_max_c'] ?? '--'}';
              _condition = today['condition'] ?? 'Unknown';
              _humidity = '${today['humidity_avg'] ?? '--'}%';
              _windSpeed = '12 km/h'; // Not in current API response
              _rainChance = '${today['rain_mm_total'] ?? 0}mm';
              _weatherIcon = _getWeatherIcon(_condition);
            }
          });
        }
      }
    } catch (e) {
      print('Error fetching weather: $e');
      if (mounted) {
        setState(() {
          _isLoadingWeather = false;
          _locationName = "Weather Unavailable";
          _condition = "Tap to retry";
        });
      }
    }
  }

  IconData _getWeatherIcon(String condition) {
    final cond = condition.toLowerCase();
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

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 12) return "good_morning".tr;
    if (hour >= 12 && hour < 17) return "good_afternoon".tr;
    if (hour >= 17 && hour < 21) return "good_evening".tr;
    return "good_night".tr;
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF59F20D);
    const backgroundDark = Color(0xFF162210);
    const surfaceDark = Color(0xFF1E2923);

    return ChatbotWrapper(
      showChatbot: true,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          final now = DateTime.now();
          if (lastPressedTime == null ||
              now.difference(lastPressedTime!) > const Duration(seconds: 2)) {
            lastPressedTime = now;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "press_back_again".tr,
                  style: GoogleFonts.inter(),
                ),
                duration: const Duration(seconds: 2),
                backgroundColor: primary,
              ),
            );
            return;
          }
          await SystemNavigator.pop();
        },
        child: Scaffold(
          backgroundColor: backgroundDark,
          body: SafeArea(
            child: Column(
              children: [
                // 🌿 Header Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (_) =>
                                  //         const ProfileSettingsScreen(),
                                  //   ),
                                  // );
                                },
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: primary,
                                      width: 2,
                                    ),
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        "https://lh3.googleusercontent.com/aida-public/AB6AXuBKb3I9fm3genTuC5RZUt-UPpXUCUFX5f_zLfP3rmiveMfOWgTJJp0PDZpgLIx0IrmHr1dLcS4KQfEMjUZzjeanoTcWbWEOruNUQEyPsPKOgIKk9cXususzkoH4-UfiNcnbn_IsKZmte-f83O8-Zub_l4bWhdcGn-waDHnP2fAdfdXAR78IusD8-cKCZ997hnDxBRwJiR-16QPOEQAJOmxzp0IQBXzGHKKesCEB1koVzY2rkT_cKqY6RbQVeiQF9TncIrce4ekOo6Uq",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: backgroundDark,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getGreeting(),
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Text(
                                "Mauli",
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: surfaceDark.withValues(alpha: 0.5),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 🌤 Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Weather Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1E2923), Color(0xFF0F180C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: Colors.white10),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _locationName,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            _temperature,
                                            style: GoogleFonts.inter(
                                              fontSize: 48,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "°C",
                                            style: GoogleFonts.inter(
                                              fontSize: 20,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        _condition,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        _weatherIcon,
                                        color: Colors.yellow,
                                        size: 44,
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 100,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "AQI 45 (Good)",
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(color: Colors.white24),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _weatherDetail("humidity", _humidity),
                                  _weatherDetail("wind", _windSpeed),
                                  _weatherDetail("rain", _rainChance),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ⚙️ Quick Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "quick_actions".tr,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "edit_grid".tr,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // 🧩 Grid Buttons
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _DashboardButton(
                              key: scanDiseaseKey,
                              icon: Icons.center_focus_strong,
                              title: "scan_disease".tr,
                              subtitle: "detect_crop_issues".tr,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CameraScreen(),
                                  ),
                                );
                              },
                            ),
                            _DashboardButton(
                              icon: Icons.smart_toy,
                              title: "advisory".tr,
                              subtitle: "ask_krishi_bot".tr,
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => const KrishiAiScanner(),
                                //   ),
                                // );
                              },
                            ),
                            _DashboardButton(
                              key: weatherKey,
                              icon: Icons.calendar_month,
                              title: "weather".tr,
                              subtitle: "five_day_forecast".tr,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const WeatherAdvisoryScreen(),
                                  ),
                                );
                              },
                            ),
                            _DashboardButton(
                              key: mandiPricesKey,
                              icon: Icons.sell,
                              title: "mandi_prices".tr,
                              subtitle: "live_market_rates".tr,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MarketScreen(),
                                  ),
                                );
                              },
                            ),
                            _DashboardButton(
                              key: schemesKey,
                              icon: Icons.policy,
                              title: "schemes".tr,
                              subtitle: "govt_benefits".tr,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const GovSchemesScreen(),
                                  ),
                                );
                              },
                            ),

                            _DashboardButton(
                              icon: Icons.history,
                              title: "history".tr,
                              subtitle: "past_scans_data".tr,
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => const HistoryScreen(),
                                //   ),
                                // );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ✅ Bottom Nav Bar
          bottomNavigationBar: const KrishiBottomNav(currentIndex: 0),
        ),
      ),
    );
  }

  Widget _weatherDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label.tr.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 10,
            color: Colors.grey[500],
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// 🔘 Dashboard Button Widget
class _DashboardButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _DashboardButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF59F20D);
    const surfaceDark = Color(0xFF1E2923);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: primary, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[500],
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

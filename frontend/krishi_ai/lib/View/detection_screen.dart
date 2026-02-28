import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_ai/View/home_screen.dart';
import 'package:krishi_ai/View/debug_screen.dart';
import 'package:krishi_ai/services/nearby_stores_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultScreen extends StatelessWidget {
  final File imageFile;
  final String diseaseName;
  final String confidence;
  final String treatment;
  final String? dosage;
  final String? prevention;
  final bool? isHealthy;
  final String? label;
  final Map<String, String>? allPredictions;

  const ResultScreen({
    super.key,
    required this.imageFile,
    required this.diseaseName,
    required this.confidence,
    required this.treatment,
    this.dosage,
    this.prevention,
    this.isHealthy,
    this.label,
    this.allPredictions,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF59F20D);
    const backgroundDark = Color(0xFF0A0F08);
    const surfaceDark = Color(0xFF162210);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: surfaceDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const KrishiAIDashboard()),
              (route) => false,
            );
          },
        ),
        title: Text(
          "Disease Analysis",
          style: GoogleFonts.spaceGrotesk(
            color: primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DebugScreen(
                    imageFile: imageFile,
                    analysisResult: {
                      'label': label ?? 'unknown',
                      'confidence': confidence,
                      'disease_name': diseaseName,
                      'treatment': treatment,
                      'dosage': dosage,
                      'prevention': prevention,
                      'is_healthy': isHealthy,
                      'all_predictions': allPredictions ?? {},
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primary.withValues(alpha: 0.25)),
                image: DecorationImage(
                  image: FileImage(imageFile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Disease Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isHealthy == true
                                ? Icons.check_circle
                                : Icons.warning,
                            color: isHealthy == true ? Colors.green : primary,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isHealthy == true
                                ? "Healthy Crop"
                                : "Disease Detected",
                            style: GoogleFonts.spaceGrotesk(
                              color: isHealthy == true ? Colors.green : primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        diseaseName,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (label != null)
                        Text(
                          label!.replaceAll('_', ' '),
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            value:
                                double.parse(confidence.replaceAll('%', '')) /
                                100,
                            color: isHealthy == true ? Colors.green : primary,
                            strokeWidth: 4,
                            backgroundColor: Colors.grey[800],
                          ),
                        ),
                        Text(
                          confidence,
                          style: GoogleFonts.spaceGrotesk(
                            color: isHealthy == true ? Colors.green : primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Confidence",
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Treatment Section
            if (isHealthy != true) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primary.withValues(alpha: 0.18)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.medication, color: primary),
                        const SizedBox(width: 8),
                        Text(
                          "Recommended Treatment",
                          style: GoogleFonts.spaceGrotesk(
                            color: primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      treatment,
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (dosage != null &&
                  dosage != "Not applicable" &&
                  dosage != "Not available")
                _buildInfoCard(
                  icon: Icons.local_pharmacy,
                  title: "Dosage Information",
                  content: dosage!,
                  primary: primary,
                ),
              if (dosage != null &&
                  dosage != "Not applicable" &&
                  dosage != "Not available")
                const SizedBox(height: 16),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.eco, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          "Healthy Crop Detected",
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Your crop appears to be healthy! Continue with regular care and monitoring.",
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (prevention != null)
              _buildInfoCard(
                icon: Icons.shield,
                title: "Prevention Tips",
                content: prevention!,
                primary: primary,
              ),
            if (prevention != null) const SizedBox(height: 16),
            if (isHealthy != true)
              _buildInfoCard(
                icon: Icons.warning_amber,
                title: "Common Symptoms",
                content: _getSymptoms(label ?? ''),
                primary: primary,
              ),
            if (isHealthy != true) const SizedBox(height: 20),
            // Market Locator Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primary.withValues(alpha: 0.15),
                    primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.store,
                          color: Color(0xFF0A0F08),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Need Pesticides?",
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Find nearby agri stores",
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: primary, size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showMarketLocator(context, primary);
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text("Locate Nearby Stores"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: backgroundDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KrishiAIDashboard(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home),
                    label: const Text("Go Home"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: surfaceDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: primary.withValues(alpha: 0.3)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Saved to History",
                            style: GoogleFonts.spaceGrotesk(),
                          ),
                          backgroundColor: primary,
                        ),
                      );
                    },
                    icon: const Icon(Icons.bookmark),
                    label: const Text("Save"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: backgroundDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color primary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162210),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  String _getSymptoms(String label) {
    final symptomsMap = {
      'Pepper__bell___Bacterial_spot':
          '• Small, dark brown spots on leaves\n• Yellow halos around spots\n• Leaf drop and defoliation\n• Fruit lesions with raised edges',
      'Potato___Early_blight':
          '• Dark brown spots with concentric rings\n• Yellow halos around lesions\n• Leaf yellowing and drop\n• Stem and tuber lesions',
      'Potato___Late_blight':
          '• Dark brown to black lesions\n• White fungal growth on leaf undersides\n• Rapid leaf decay in humid conditions\n• Stem and tuber rot',
      'Tomato_Bacterial_spot':
          '• Small, dark brown spots on leaves\n• Yellow halos around spots\n• Fruit spots with raised, rough texture\n• Leaf drop in severe cases',
      'Tomato_Early_blight':
          '• Dark brown spots with concentric rings\n• Target-like lesions on leaves\n• Yellowing and defoliation\n• Stem cankers near soil line',
      'Tomato_Late_blight':
          '• Dark brown to black lesions\n• White fungal growth on undersides\n• Rapid leaf decay in humid conditions\n• Stem lesions and fruit rot',
      'Tomato_Leaf_Mold':
          '• Yellow spots on upper leaf surface\n• Olive-green to brown fuzzy growth underneath\n• Leaf curling and yellowing\n• Reduced fruit quality',
      'Tomato_Septoria_leaf_spot':
          '• Small, circular spots with dark borders\n• Gray centers with tiny black specks\n• Lower leaves affected first\n• Progressive defoliation',
      'Tomato_Spider_mites_Two_spotted_spider_mite':
          '• Fine webbing on leaves\n• Yellow stippling on leaf surface\n• Leaves become bronze or yellow\n• Tiny moving dots on undersides',
      'Tomato__Target_Spot':
          '• Brown spots with concentric rings\n• Target-like appearance\n• Leaf yellowing and drop\n• Fruit lesions with dark centers',
      'Tomato__Tomato_YellowLeaf__Curl_Virus':
          '• Upward curling of leaves\n• Yellow leaf margins\n• Stunted plant growth\n• Reduced fruit production',
      'Tomato__Tomato_mosaic_virus':
          '• Mottled light and dark green patterns\n• Leaf distortion and curling\n• Stunted growth\n• Reduced fruit quality',
    };
    return symptomsMap[label] ??
        '• Observe any unusual discoloration\n• Check for spots or lesions\n• Monitor plant growth patterns\n• Look for signs of pest activity';
  }
}

void _showMarketLocator(BuildContext context, Color primary) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _NearbyStoresSheet(primary: primary),
  );
}

class _NearbyStoresSheet extends StatefulWidget {
  final Color primary;

  const _NearbyStoresSheet({required this.primary});

  @override
  State<_NearbyStoresSheet> createState() => _NearbyStoresSheetState();
}

class _NearbyStoresSheetState extends State<_NearbyStoresSheet> {
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _stores = [];

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  Future<void> _fetchStores() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('🏪 Fetching nearby stores...');
      final data = await NearbyStoresService.fetchNearbyStores();

      setState(() {
        _stores = data['stores'] ?? [];
        _isLoading = false;
      });

      print('✅ Successfully loaded ${_stores.length} stores');

      if (data['note'] != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Showing sample stores - Create /nearby-stores endpoint for real data',
              style: GoogleFonts.spaceGrotesk(fontSize: 12),
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      print('❌ Error fetching stores: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF0A0F08),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.store, color: widget.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nearby Agri Stores",
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Pesticides & preventive measures",
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: widget.primary),
                        const SizedBox(height: 16),
                        Text(
                          "Finding nearby stores...",
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Failed to load stores",
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _fetchStores,
                            icon: const Icon(Icons.refresh),
                            label: const Text("Retry"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.primary,
                              foregroundColor: const Color(0xFF0A0F08),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : _stores.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.store_outlined,
                            color: Colors.grey[600],
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No stores found nearby",
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Try again or check your location settings",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchStores,
                    color: widget.primary,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _stores.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final store = _stores[index];
                        return _buildStoreCard(
                          storeName: store['name'] ?? 'Unknown Store',
                          distance: store['distance'] ?? 'N/A',
                          address: store['address'] ?? 'Address not available',
                          rating: store['rating']?.toString() ?? '0.0',
                          isOpen: store['is_open'] ?? true,
                          phone: store['phone'] ?? '',
                          latitude: store['latitude'],
                          longitude: store['longitude'],
                          primary: widget.primary,
                          context: context,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

Widget _buildStoreCard({
  required String storeName,
  required String distance,
  required String address,
  required String rating,
  required bool isOpen,
  required String phone,
  double? latitude,
  double? longitude,
  required Color primary,
  required BuildContext context,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF162210),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeName,
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: primary, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: GoogleFonts.spaceGrotesk(
                          color: primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isOpen
                    ? primary.withValues(alpha: 0.15)
                    : Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isOpen ? "Open" : "Closed",
                style: GoogleFonts.spaceGrotesk(
                  color: isOpen ? primary : Colors.red,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          address,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  await _openGoogleMaps(
                    context,
                    storeName,
                    latitude,
                    longitude,
                    address,
                    primary,
                  );
                },
                icon: const Icon(Icons.directions, size: 18),
                label: const Text("Navigate"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: BorderSide(color: primary.withValues(alpha: 0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: phone.isNotEmpty
                    ? () async {
                        await _makePhoneCall(context, phone, primary);
                      }
                    : null,
                icon: const Icon(Icons.phone, size: 18),
                label: const Text("Call"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: BorderSide(color: primary.withValues(alpha: 0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Future<void> _openGoogleMaps(
  BuildContext context,
  String storeName,
  double? latitude,
  double? longitude,
  String address,
  Color primary,
) async {
  try {
    Uri? mapsUri;

    if (latitude != null && longitude != null) {
      mapsUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      );
    } else if (address.isNotEmpty) {
      final encodedAddress = Uri.encodeComponent(address);
      mapsUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
      );
    }

    if (mapsUri != null) {
      print('🗺️ Opening Google Maps: $mapsUri');

      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
        print('✅ Successfully opened Google Maps');
      } else {
        throw Exception('Could not launch Google Maps');
      }
    } else {
      throw Exception('No location data available');
    }
  } catch (e) {
    print('❌ Error opening Google Maps: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Could not open Google Maps: $e",
            style: GoogleFonts.spaceGrotesk(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

Future<void> _makePhoneCall(
  BuildContext context,
  String phone,
  Color primary,
) async {
  try {
    final telUri = Uri.parse('tel:$phone');

    print('📞 Initiating call to: $phone');

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
      print('✅ Successfully initiated call');
    } else {
      throw Exception('Could not launch phone dialer');
    }
  } catch (e) {
    print('❌ Error making phone call: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Could not make call: $e",
            style: GoogleFonts.spaceGrotesk(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

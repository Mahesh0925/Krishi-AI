import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_ai/View/home_screen.dart';
import 'package:krishi_ai/View/debug_screen.dart';

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

              // Dosage Section
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
              // Healthy crop message
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

            // Prevention Section
            if (prevention != null)
              _buildInfoCard(
                icon: Icons.shield,
                title: "Prevention Tips",
                content: prevention!,
                primary: primary,
              ),
            if (prevention != null) const SizedBox(height: 16),

            // Symptoms Section (only for diseased crops)
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
                      // Save to history
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
    builder: (context) => Container(
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
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.store, color: primary, size: 24),
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
          // Store List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildStoreCard(
                  storeName: "Green Valley Agro Center",
                  distance: "1.2 km",
                  address: "Shop 12, Market Road, Mumbai",
                  rating: "4.5",
                  isOpen: true,
                  phone: "+91 98765 43210",
                  primary: primary,
                  context: context,
                ),
                const SizedBox(height: 12),
                _buildStoreCard(
                  storeName: "Farmers Choice Pesticides",
                  distance: "2.5 km",
                  address: "Near Bus Stand, Andheri West",
                  rating: "4.3",
                  isOpen: true,
                  phone: "+91 98765 43211",
                  primary: primary,
                  context: context,
                ),
                const SizedBox(height: 12),
                _buildStoreCard(
                  storeName: "Krishi Seva Kendra",
                  distance: "3.8 km",
                  address: "Main Market, Borivali",
                  rating: "4.7",
                  isOpen: false,
                  phone: "+91 98765 43212",
                  primary: primary,
                  context: context,
                ),
                const SizedBox(height: 12),
                _buildStoreCard(
                  storeName: "Agri Solutions Hub",
                  distance: "4.2 km",
                  address: "Industrial Area, Malad",
                  rating: "4.4",
                  isOpen: true,
                  phone: "+91 98765 43213",
                  primary: primary,
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildStoreCard({
  required String storeName,
  required String distance,
  required String address,
  required String rating,
  required bool isOpen,
  required String phone,
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
                onPressed: () {
                  // Open maps/navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Opening navigation to $storeName",
                        style: GoogleFonts.spaceGrotesk(),
                      ),
                      backgroundColor: primary,
                    ),
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
                onPressed: () {
                  // Make phone call
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Calling $phone",
                        style: GoogleFonts.spaceGrotesk(),
                      ),
                      backgroundColor: primary,
                    ),
                  );
                },
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

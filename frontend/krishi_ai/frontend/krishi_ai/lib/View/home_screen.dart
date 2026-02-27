import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_ai/View/bottom_nav_bar.dart';
import 'package:krishi_ai/View/camera_screen.dart';
import 'package:krishi_ai/widgets/chatbot_wrapper.dart';

class KrishiAIDashboard extends StatefulWidget {
  const KrishiAIDashboard({super.key});

  @override
  State<KrishiAIDashboard> createState() => _KrishiAIDashboardState();
}

class _KrishiAIDashboardState extends State<KrishiAIDashboard> {
  int selectedIndex = 0;
  DateTime? lastPressedTime; // ✅ Track last back press

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 12) return "Good Morning,";
    if (hour >= 12 && hour < 17) return "Good Afternoon,";
    if (hour >= 17 && hour < 21) return "Good Evening,";
    return "Good Night,";
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
                  "Press back again to exit",
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
                                "Rajesh Kumar",
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
                                            "Mumbai, India",
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
                                            "28°",
                                            style: GoogleFonts.inter(
                                              fontSize: 48,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "C",
                                            style: GoogleFonts.inter(
                                              fontSize: 20,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Sunny • Good for irrigation",
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
                                      const Icon(
                                        Icons.wb_sunny,
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
                                  _weatherDetail("Humidity", "62%"),
                                  _weatherDetail("Wind", "12 km/h"),
                                  _weatherDetail("Rain", "0%"),
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
                              "Quick Actions",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Edit Grid",
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
                              icon: Icons.center_focus_strong,
                              title: "Scan Disease",
                              subtitle: "Detect crop issues",
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
                              title: "Advisory",
                              subtitle: "Ask Krishi Bot",
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
                              icon: Icons.calendar_month,
                              title: "Weather",
                              subtitle: "7-day forecast",
                              onTap: () {
                                debugPrint("Weather clicked");
                              },
                            ),
                            _DashboardButton(
                              icon: Icons.sell,
                              title: "Mandi Prices",
                              subtitle: "Live market rates",
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => const MarketScreen(),
                                //   ),
                                // );
                              },
                            ),
                            _DashboardButton(
                              icon: Icons.policy,
                              title: "Schemes",
                              subtitle: "Govt. benefits",
                              onTap: () {
                                debugPrint("Schemes clicked");
                              },
                            ),
                            _DashboardButton(
                              icon: Icons.spa,
                              title: "Fertilizer",
                              subtitle: "Dosage calculator",
                              onTap: () {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (_) =>
                                //           const FertilizerCalculatorScreen(),
                                //     ),
                                //   );
                              },
                            ),
                            _DashboardButton(
                              icon: Icons.agriculture,
                              title: "Rentals",
                              subtitle: "Equipment hire",
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => const RentalsScreen(),
                                //   ),
                                // );
                              },
                            ),
                            _DashboardButton(
                              icon: Icons.history,
                              title: "History",
                              subtitle: "Past scans & data",
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
          label.toUpperCase(),
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

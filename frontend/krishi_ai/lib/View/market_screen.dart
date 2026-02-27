import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_ai/View/bottom_nav_bar.dart';
import 'package:krishi_ai/View/home_screen.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF59F20D);
    const Color backgroundDark = Color(0xFF162210);
    const Color surfaceDark = Color(0xFF1E2923);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const KrishiAIDashboard()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundDark,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: surfaceDark,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.storefront_outlined,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Market Prices",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: surfaceDark,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔸 Category Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _categoryButton("Nearby Mandis", true),
                      const SizedBox(width: 8),
                      _categoryButton("Favorites", false),
                      const SizedBox(width: 8),
                      _categoryButton("Top Gainers", false),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 🌾 Top Commodity Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Top Commodity",
                                style: GoogleFonts.inter(
                                  color: Colors.grey[400],
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    "Wheat (Sharbati)",
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      "+4.2%",
                                      style: GoogleFonts.inter(
                                        color: primary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Azadpur Mandi, Delhi",
                                style: GoogleFonts.inter(
                                  color: Colors.grey[500],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "₹2,450",
                                style: GoogleFonts.inter(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              ),
                              Text(
                                "per Quintal",
                                style: GoogleFonts.inter(
                                  color: Colors.grey[500],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Chart area
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              primary.withOpacity(0.15),
                              primary.withOpacity(0),
                            ],
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                        ),
                        child: CustomPaint(painter: _ChartPainter()),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "10 May",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          Text(
                            "15 May",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          Text(
                            "20 May",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          Text(
                            "Today",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // 📊 Live Rates Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Live Rates",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.filter_list, color: primary, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "Sort by: Date",
                          style: GoogleFonts.inter(
                            color: primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 💰 Market Items
                _marketItem(
                  icon: Icons.eco,
                  name: "Onion (Red)",
                  mandi: "Lasalgaon Mandi • 4h ago",
                  price: "₹1,250",
                  change: "+1.2%",
                  isPositive: true,
                ),
                _marketItem(
                  icon: Icons.grass,
                  name: "Paddy (Basmati)",
                  mandi: "Karnal Mandi • 6h ago",
                  price: "₹3,900",
                  change: "+0.8%",
                  isPositive: true,
                ),
                _marketItem(
                  icon: Icons.grain,
                  name: "Soybean",
                  mandi: "Indore Mandi • 1d ago",
                  price: "₹4,650",
                  change: "Stable",
                  isPositive: true,
                ),
                const SizedBox(height: 30),

                // 🔔 Alert Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.05),
                    border: Border.all(color: primary.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Want precise alerts?",
                              style: GoogleFonts.inter(
                                color: primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Set price alerts for your favorite crops and mandis.",
                              style: GoogleFonts.inter(
                                color: Colors.grey[400],
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: backgroundDark,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Set Alert",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const KrishiBottomNav(currentIndex: 3),
      ),
    );
  }

  // 🔘 Category Button
  Widget _categoryButton(String title, bool selected) {
    const Color primary = Color(0xFF59F20D);
    const Color surfaceDark = Color(0xFF1E2923);
    const Color backgroundDark = Color(0xFF162210);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? primary : surfaceDark,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: selected ? backgroundDark : Colors.grey[400],
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  // 🧾 Market Item
  Widget _marketItem({
    IconData? icon,
    required String name,
    required String mandi,
    required String price,
    required String change,
    required bool isPositive,
  }) {
    const Color surfaceDark = Color(0xFF1E2923);
    const Color backgroundDark = Color(0xFF162210);
    const Color primary = Color(0xFF59F20D);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: backgroundDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Icon(icon, color: primary, size: 26),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    mandi,
                    style: GoogleFonts.inter(
                      color: Colors.grey[500],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                change,
                style: GoogleFonts.inter(
                  color: change == "Stable"
                      ? Colors.grey[500]
                      : (isPositive ? primary : Colors.red),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 📈 Chart Painter
class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint line = Paint()
      ..color = const Color(0xFF59F20D)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.75,
      size.width * 0.5,
      size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.4,
      size.width,
      size.height * 0.2,
    );
    canvas.drawPath(path, line);

    final Paint dot = Paint()..color = const Color(0xFF59F20D);
    canvas.drawCircle(Offset(size.width, size.height * 0.2), 4, dot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

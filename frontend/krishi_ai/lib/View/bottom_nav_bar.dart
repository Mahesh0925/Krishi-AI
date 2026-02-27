import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:krishi_ai/View/camera_screen.dart';
import 'package:krishi_ai/View/home_screen.dart';
import 'package:krishi_ai/View/land_measure_screen.dart';
import 'package:krishi_ai/View/market_screen.dart';
import 'package:krishi_ai/View/profile_setting.dart';

class KrishiBottomNav extends StatelessWidget {
  final int currentIndex;
  const KrishiBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF59F20D);
    const surfaceDark = Color(0xFF1E2923);

    return CurvedNavigationBar(
      height: 65,
      index: currentIndex,
      backgroundColor: Colors.transparent,
      color: surfaceDark,
      buttonBackgroundColor: primary,
      animationDuration: const Duration(milliseconds: 300),
      items: const [
        Icon(Icons.home_outlined, size: 30, color: Colors.white), // 🏠 Home
        Icon(
          Icons.groups_outlined,
          size: 30,
          color: Colors.white,
        ), // 👥 Community
        Icon(
          Icons.qr_code_scanner,
          size: 30,
          color: Colors.white,
        ), // 📷 Scanner
        Icon(
          Icons.storefront_outlined,
          size: 30,
          color: Colors.white,
        ), // 🏪 Market
        Icon(Icons.person_outline, size: 30, color: Colors.white), // 👤 Profile
      ],
      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KrishiAIDashboard()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LandMeasureScreen()),
            );
            break;
          case 2:
            Navigator.push( 
              context,
              MaterialPageRoute(builder: (_) => const CameraScreen()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MarketScreen()),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileSettingsScreen()),
            );
            break;
        }
      },
    );
  }
}

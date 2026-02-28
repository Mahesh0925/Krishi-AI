import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_ai/View/bottom_nav_bar.dart';
import 'package:krishi_ai/View/change_language.dart';
import 'package:krishi_ai/View/edit_profile.dart';
import 'package:krishi_ai/View/home_screen.dart';
import 'package:krishi_ai/View/login_screen.dart';
import 'package:krishi_ai/utils/tutorial_helper.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: surfaceDark,
          elevation: 0,
          title: Text(
            "profile_settings".tr,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 👤 Profile Picture
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primary, width: 3),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuBKb3I9fm3genTuC5RZUt-UPpXUCUFX5f_zLfP3rmiveMfOWgTJJp0PDZpgLIx0IrmHr1dLcS4KQfEMjUZzjeanoTcWbWEOruNUQEyPsPKOgIKk9cXususzkoH4-UfiNcnbn_IsKZmte-f83O8-Zub_l4bWhdcGn-waDHnP2fAdfdXAR78IusD8-cKCZ997hnDxBRwJiR-16QPOEQAJOmxzp0IQBXzGHKKesCEB1koVzY2rkT_cKqY6RbQVeiQF9TncIrce4ekOo6Uq",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Mauli",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "mauli@gmail.com",
                style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13),
              ),
              const SizedBox(height: 25),

              // ⚙️ Settings Options
              _settingsTile(
                icon: Icons.edit_outlined,
                title: "edit_profile".tr,
                subtitle: "change_name_photo".tr,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const KrishiAIFarmerProfile(),
                    ),
                  );
                },
              ),
              _settingsTile(
                icon: Icons.notifications_active_outlined,
                title: "notifications".tr,
                subtitle: "manage_alert_preferences".tr,
                onTap: () {
                  debugPrint("Notifications tapped");
                },
              ),
              _settingsTile(
                icon: Icons.language_outlined,
                title: "language".tr,
                subtitle: "select_preferred_language".tr,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LanguageSelectionScreen(),
                    ),
                  );
                },
              ),
              _settingsTile(
                icon: Icons.privacy_tip_outlined,
                title: "privacy_security".tr,
                subtitle: "manage_permissions".tr,
                onTap: () {
                  debugPrint("Privacy tapped");
                },
              ),
              _settingsTile(
                icon: Icons.help_outline,
                title: "help_support".tr,
                subtitle: "faqs_contact".tr,
                onTap: () {
                  debugPrint("Help tapped");
                },
              ),

              // 🧪 TEMPORARY: Reset Tutorial Button (Remove before production)
              _settingsTile(
                icon: Icons.refresh,
                title: "Reset Tutorial (Testing)",
                subtitle: "Show tutorial again on next app start",
                onTap: () async {
                  await TutorialHelper.resetTutorial();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Tutorial reset! Please restart the app to see it again.",
                        style: GoogleFonts.inter(),
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                color: Colors.orange,
              ),

              _settingsTile(
                icon: Icons.logout,
                title: "logout".tr,
                subtitle: "sign_out".tr,
                onTap: () {
                  _showLogoutDialog(context);
                },
                color: Colors.redAccent,
              ),

              const SizedBox(height: 35),
              Text(
                "version".tr,
                style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 11),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        bottomNavigationBar: const KrishiBottomNav(currentIndex: 4),
      ),
    );
  }

  // 🔹 Reusable Settings Tile
  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color color = Colors.white,
  }) {
    const Color surfaceDark = Color(0xFF1E2923);
    const Color primary = Color(0xFF59F20D);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surfaceDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  // 🔴 Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    const Color primary = Color(0xFF59F20D);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "logout".tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "logout_confirm".tr,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "cancel".tr,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const KrishiAILoginScreen()),
              );
            },
            child: Text("logout".tr, style: const TextStyle(color: primary)),
          ),
        ],
      ),
    );
  }
}

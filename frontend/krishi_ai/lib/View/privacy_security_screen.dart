import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _locationAccess = true;
  bool _cameraAccess = true;
  bool _storageAccess = true;
  bool _notificationAccess = true;

  @override
  Widget build(BuildContext context) {
    const Color backgroundDark = Color(0xFF162210);
    const Color surfaceDark = Color(0xFF1E2923);

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
          "privacy_security".tr,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Permissions Section
            _sectionHeader("App Permissions"),
            const SizedBox(height: 12),
            _permissionTile(
              icon: Icons.location_on,
              title: "Location Access",
              subtitle: "Required for weather and nearby stores",
              value: _locationAccess,
              onChanged: (val) => setState(() => _locationAccess = val),
            ),
            _permissionTile(
              icon: Icons.camera_alt,
              title: "Camera Access",
              subtitle: "Required for crop disease scanning",
              value: _cameraAccess,
              onChanged: (val) => setState(() => _cameraAccess = val),
            ),
            _permissionTile(
              icon: Icons.storage,
              title: "Storage Access",
              subtitle: "Required to save scan history",
              value: _storageAccess,
              onChanged: (val) => setState(() => _storageAccess = val),
            ),
            _permissionTile(
              icon: Icons.notifications,
              title: "Notifications",
              subtitle: "Weather alerts and scheme updates",
              value: _notificationAccess,
              onChanged: (val) => setState(() => _notificationAccess = val),
            ),

            const SizedBox(height: 24),

            // Data Privacy Section
            _sectionHeader("Data Privacy"),
            const SizedBox(height: 12),
            _infoTile(
              icon: Icons.shield,
              title: "Data Protection",
              subtitle: "Your data is encrypted and stored securely",
              onTap: () => _showDataProtectionDialog(),
            ),
            _infoTile(
              icon: Icons.delete_outline,
              title: "Delete Account",
              subtitle: "Permanently delete your account and data",
              onTap: () => _showDeleteAccountDialog(),
              color: Colors.red,
            ),
            _infoTile(
              icon: Icons.download,
              title: "Download My Data",
              subtitle: "Get a copy of your personal data",
              onTap: () => _showDownloadDataDialog(),
            ),

            const SizedBox(height: 24),

            // Security Section
            _sectionHeader("Security"),
            const SizedBox(height: 12),
            _infoTile(
              icon: Icons.lock,
              title: "Change Password",
              subtitle: "Update your account password",
              onTap: () => _showChangePasswordDialog(),
            ),
            _infoTile(
              icon: Icons.security,
              title: "Two-Factor Authentication",
              subtitle: "Add extra security to your account",
              onTap: () => _show2FADialog(),
            ),
            _infoTile(
              icon: Icons.devices,
              title: "Active Sessions",
              subtitle: "Manage devices logged into your account",
              onTap: () => _showActiveSessionsDialog(),
            ),

            const SizedBox(height: 24),

            // Privacy Policy
            _sectionHeader("Legal"),
            const SizedBox(height: 12),
            _infoTile(
              icon: Icons.description,
              title: "Privacy Policy",
              subtitle: "Read our privacy policy",
              onTap: () => _showPrivacyPolicyDialog(),
            ),
            _infoTile(
              icon: Icons.gavel,
              title: "Terms of Service",
              subtitle: "Read our terms and conditions",
              onTap: () => _showTermsDialog(),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF59F20D),
      ),
    );
  }

  Widget _permissionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    const Color surfaceDark = Color(0xFF1E2923);
    const Color primary = Color(0xFF59F20D);

    return Container(
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
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
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
          Switch(value: value, onChanged: onChanged, activeColor: primary),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
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
                color: primary.withValues(alpha: 0.1),
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
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  void _showDataProtectionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            const Icon(Icons.shield, color: Color(0xFF59F20D)),
            const SizedBox(width: 10),
            const Text(
              "Data Protection",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            "• All your data is encrypted using industry-standard AES-256 encryption\n\n"
            "• Your crop images are stored securely and never shared with third parties\n\n"
            "• Personal information is protected and used only for app functionality\n\n"
            "• We comply with data protection regulations",
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK", style: TextStyle(color: Color(0xFF59F20D))),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Delete Account",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to delete your account? This action cannot be undone.\n\n"
          "All your data including:\n"
          "• Scan history\n"
          "• Profile information\n"
          "• Saved preferences\n\n"
          "will be permanently deleted.",
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Account deletion request submitted",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDownloadDataDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Download My Data",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "We will prepare a copy of your data and send it to your registered email within 48 hours.\n\n"
          "The data will include:\n"
          "• Profile information\n"
          "• Scan history\n"
          "• App preferences\n"
          "• Usage statistics",
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Data download request submitted",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: const Color(0xFF59F20D),
                ),
              );
            },
            child: const Text(
              "Request",
              style: TextStyle(color: Color(0xFF59F20D)),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Change Password",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Current Password",
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF59F20D)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "New Password",
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF59F20D)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Confirm New Password",
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF59F20D)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Password changed successfully",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: const Color(0xFF59F20D),
                ),
              );
            },
            child: const Text(
              "Change",
              style: TextStyle(color: Color(0xFF59F20D)),
            ),
          ),
        ],
      ),
    );
  }

  void _show2FADialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Two-Factor Authentication",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Enable two-factor authentication for extra security.\n\n"
          "You will receive a verification code via SMS or email each time you log in from a new device.",
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "2FA enabled successfully",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: const Color(0xFF59F20D),
                ),
              );
            },
            child: const Text(
              "Enable",
              style: TextStyle(color: Color(0xFF59F20D)),
            ),
          ),
        ],
      ),
    );
  }

  void _showActiveSessionsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Active Sessions",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sessionTile("Android Phone", "Current Device", true),
            _sessionTile("Windows PC", "Last active 2 days ago", false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Close",
              style: TextStyle(color: Color(0xFF59F20D)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionTile(String device, String info, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isCurrent ? Icons.phone_android : Icons.computer,
            color: const Color(0xFF59F20D),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  info,
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          if (!isCurrent)
            TextButton(
              onPressed: () {},
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            "Last updated: February 2026\n\n"
            "1. Information We Collect\n"
            "We collect information you provide directly, including name, email, phone number, and farm details.\n\n"
            "2. How We Use Your Information\n"
            "• Provide crop disease detection services\n"
            "• Send weather alerts and farming tips\n"
            "• Improve our AI models\n"
            "• Notify about government schemes\n\n"
            "3. Data Sharing\n"
            "We do not sell your personal data. We may share anonymized data for research purposes.\n\n"
            "4. Data Security\n"
            "We use encryption and secure servers to protect your data.\n\n"
            "5. Your Rights\n"
            "You can access, update, or delete your data anytime.",
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Close",
              style: TextStyle(color: Color(0xFF59F20D)),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Terms of Service",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            "Last updated: February 2026\n\n"
            "1. Acceptance of Terms\n"
            "By using Krishi AI, you agree to these terms.\n\n"
            "2. Service Description\n"
            "Krishi AI provides crop disease detection, weather forecasts, and farming information.\n\n"
            "3. User Responsibilities\n"
            "• Provide accurate information\n"
            "• Use the app for lawful purposes\n"
            "• Keep your account secure\n\n"
            "4. Disclaimer\n"
            "Disease detection is AI-based and should be verified by agricultural experts.\n\n"
            "5. Limitation of Liability\n"
            "We are not liable for crop losses or damages based on app recommendations.\n\n"
            "6. Changes to Terms\n"
            "We may update these terms. Continued use means acceptance.",
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Close",
              style: TextStyle(color: Color(0xFF59F20D)),
            ),
          ),
        ],
      ),
    );
  }
}

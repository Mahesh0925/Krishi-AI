import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
          "help_support".tr,
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
            // Contact Support Section
            _sectionHeader("Contact Support"),
            const SizedBox(height: 12),
            _contactTile(
              icon: Icons.phone,
              title: "Call Us",
              subtitle: "+91 1800-XXX-XXXX (Toll Free)",
              onTap: () => _makePhoneCall("+911800XXXXXXX"),
            ),
            _contactTile(
              icon: Icons.email,
              title: "Email Support",
              subtitle: "support@krishiai.com",
              onTap: () => _sendEmail("support@krishiai.com"),
            ),
            _contactTile(
              icon: Icons.chat,
              title: "Live Chat",
              subtitle: "Chat with our support team",
              onTap: () => _showChatDialog(context),
            ),
            _contactTile(
              icon: Icons.language,
              title: "Visit Website",
              subtitle: "www.krishiai.com",
              onTap: () => _openWebsite("https://www.krishiai.com"),
            ),

            const SizedBox(height: 24),

            // FAQs Section
            _sectionHeader("Frequently Asked Questions"),
            const SizedBox(height: 12),
            _faqTile(
              question: "How does crop disease detection work?",
              answer:
                  "Our AI analyzes crop images using machine learning to identify diseases. Simply take a photo of the affected plant, and our system will provide diagnosis and treatment recommendations.",
            ),
            _faqTile(
              question: "Is the app free to use?",
              answer:
                  "Yes! Krishi AI is completely free for all farmers. We believe in supporting agriculture through technology.",
            ),
            _faqTile(
              question: "How accurate is the disease detection?",
              answer:
                  "Our AI model has 90%+ accuracy. However, we recommend consulting with agricultural experts for critical decisions.",
            ),
            _faqTile(
              question: "Can I use the app offline?",
              answer:
                  "Some features like viewing saved scans work offline. However, disease detection, weather updates, and mandi prices require internet connection.",
            ),
            _faqTile(
              question: "How do I get weather alerts?",
              answer:
                  "Enable notifications in your device settings. We'll send alerts for severe weather conditions in your area.",
            ),
            _faqTile(
              question: "Where does mandi price data come from?",
              answer:
                  "We fetch real-time data from government agricultural market committees (APMCs) across India.",
            ),

            const SizedBox(height: 24),

            // Tutorials Section
            _sectionHeader("Tutorials & Guides"),
            const SizedBox(height: 12),
            _tutorialTile(
              icon: Icons.camera_alt,
              title: "How to Scan Crop Disease",
              subtitle: "Step-by-step guide",
              onTap: () => _showTutorialDialog(
                context,
                "How to Scan Crop Disease",
                "1. Open the app and tap 'Scan Disease'\n\n"
                    "2. Take a clear photo of the affected leaf or plant part\n\n"
                    "3. Ensure good lighting and focus\n\n"
                    "4. Wait for AI analysis (5-10 seconds)\n\n"
                    "5. View disease diagnosis and treatment recommendations\n\n"
                    "6. Save the scan for future reference",
              ),
            ),
            _tutorialTile(
              icon: Icons.cloud,
              title: "Understanding Weather Forecasts",
              subtitle: "Make better farming decisions",
              onTap: () => _showTutorialDialog(
                context,
                "Understanding Weather Forecasts",
                "• Temperature: Plan irrigation and harvesting\n\n"
                    "• Rainfall: Prepare for wet or dry conditions\n\n"
                    "• Humidity: Monitor for disease-prone conditions\n\n"
                    "• Wind Speed: Protect crops from strong winds\n\n"
                    "• 5-Day Forecast: Plan your farming activities ahead",
              ),
            ),
            _tutorialTile(
              icon: Icons.store,
              title: "Using Mandi Prices",
              subtitle: "Get best rates for your crops",
              onTap: () => _showTutorialDialog(
                context,
                "Using Mandi Prices",
                "1. Select your state and district\n\n"
                    "2. Choose the crop you want to sell\n\n"
                    "3. View current market prices\n\n"
                    "4. Compare prices across different mandis\n\n"
                    "5. Plan your selling strategy for maximum profit",
              ),
            ),
            _tutorialTile(
              icon: Icons.policy,
              title: "Accessing Government Schemes",
              subtitle: "Get benefits and subsidies",
              onTap: () => _showTutorialDialog(
                context,
                "Accessing Government Schemes",
                "1. Browse available schemes in your area\n\n"
                    "2. Check eligibility criteria\n\n"
                    "3. Read scheme details and benefits\n\n"
                    "4. Follow application instructions\n\n"
                    "5. Contact local agriculture office for assistance",
              ),
            ),

            const SizedBox(height: 24),

            // Feedback Section
            _sectionHeader("Feedback"),
            const SizedBox(height: 12),
            _feedbackTile(
              icon: Icons.star,
              title: "Rate Our App",
              subtitle: "Share your experience",
              onTap: () => _showRatingDialog(context),
            ),
            _feedbackTile(
              icon: Icons.bug_report,
              title: "Report a Bug",
              subtitle: "Help us improve",
              onTap: () => _showBugReportDialog(context),
            ),
            _feedbackTile(
              icon: Icons.lightbulb,
              title: "Suggest a Feature",
              subtitle: "Share your ideas",
              onTap: () => _showFeatureSuggestionDialog(context),
            ),

            const SizedBox(height: 24),

            // About Section
            _sectionHeader("About"),
            const SizedBox(height: 12),
            _infoCard(
              "Krishi AI is dedicated to empowering farmers with AI-powered tools for better crop management. "
              "Our mission is to make farming smarter, easier, and more profitable.\n\n"
              "Version: 1.0.0\n"
              "© 2026 Krishi AI. All rights reserved.",
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

  Widget _contactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
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
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _faqTile({required String question, required String answer}) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      backgroundColor: const Color(0xFF1E2923),
      collapsedBackgroundColor: const Color(0xFF1E2923),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Colors.white10),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Colors.white10),
      ),
      title: Text(
        question,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      iconColor: const Color(0xFF59F20D),
      collapsedIconColor: Colors.grey,
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Text(
            answer,
            style: GoogleFonts.inter(
              color: Colors.grey[400],
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tutorialTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return _contactTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  Widget _feedbackTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return _contactTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  Widget _infoCard(String text) {
    const Color surfaceDark = Color(0xFF1E2923);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: Colors.grey[400],
          fontSize: 13,
          height: 1.6,
        ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Krishi AI Support Request',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _openWebsite(String url) async {
    final Uri launchUri = Uri.parse(url);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }

  void _showChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            const Icon(Icons.chat, color: Color(0xFF59F20D)),
            const SizedBox(width: 10),
            const Text(
              "Live Chat",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          "Our support team is available:\n\n"
          "Monday - Saturday\n"
          "9:00 AM - 6:00 PM IST\n\n"
          "Average response time: 5 minutes",
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Open chat functionality
            },
            child: const Text(
              "Start Chat",
              style: TextStyle(color: Color(0xFF59F20D)),
            ),
          ),
        ],
      ),
    );
  }

  void _showTutorialDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Got it!",
              style: TextStyle(color: Color(0xFF59F20D)),
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    int rating = 0;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E2923),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Rate Krishi AI",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "How would you rate your experience?",
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: const Color(0xFF59F20D),
                      size: 32,
                    ),
                    onPressed: () => setState(() => rating = index + 1),
                  );
                }),
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
                      "Thank you for your feedback!",
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: const Color(0xFF59F20D),
                  ),
                );
              },
              child: const Text(
                "Submit",
                style: TextStyle(color: Color(0xFF59F20D)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBugReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Report a Bug",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Describe the issue you're facing...",
                hintStyle: const TextStyle(color: Colors.grey),
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
                    "Bug report submitted. Thank you!",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: const Color(0xFF59F20D),
                ),
              );
            },
            child: const Text(
              "Submit",
              style: TextStyle(color: Color(0xFF59F20D)),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeatureSuggestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Suggest a Feature",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "What feature would you like to see?",
                hintStyle: const TextStyle(color: Colors.grey),
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
                    "Feature suggestion submitted. Thank you!",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: const Color(0xFF59F20D),
                ),
              );
            },
            child: const Text(
              "Submit",
              style: TextStyle(color: Color(0xFF59F20D)),
            ),
          ),
        ],
      ),
    );
  }
}

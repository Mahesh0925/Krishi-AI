import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_ai/View/login_screen.dart';

class KrishiLanguageScreen extends StatefulWidget {
  const KrishiLanguageScreen({super.key});

  @override
  State<KrishiLanguageScreen> createState() => _KrishiLanguageScreenState();
}

class _KrishiLanguageScreenState extends State<KrishiLanguageScreen> {
  String selectedLang = "Hindi";

  @override
  Widget build(BuildContext context) {
    const emeraldDeep = Color(0xFF062C1E);
    const charcoalDark = Color(0xFF1A1C1A);
    const limeGlow = Color(0xFFBCFF00);
    const primaryGreen = Color(0xFF13EC13);

    return WillPopScope(
      onWillPop: () async {
        // ✅ Close the app when back button pressed
        await SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: emeraldDeep,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🌿 Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.eco, color: limeGlow, size: 40),
                      ),
                      Text(
                        "Krishi AI",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Choose your preferred language to start farming smarter.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // 🌍 Language Buttons
                      _languageButton(
                        title: "Hindi",
                        subtitle: "हिन्दी",
                        icon: Icons.translate,
                        isSelected: selectedLang == "Hindi",
                        onTap: () => setState(() => selectedLang = "Hindi"),
                      ),
                      const SizedBox(height: 16),
                      _languageButton(
                        title: "Marathi",
                        subtitle: "मराठी",
                        icon: Icons.language,
                        isSelected: selectedLang == "Marathi",
                        onTap: () => setState(() => selectedLang = "Marathi"),
                      ),
                      const SizedBox(height: 16),
                      _languageButton(
                        title: "English",
                        subtitle: "English",
                        icon: Icons.abc,
                        isSelected: selectedLang == "English",
                        onTap: () => setState(() => selectedLang = "English"),
                      ),

                      const SizedBox(height: 36),

                      // 👨‍🌾 Farmer Image Card
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://lh3.googleusercontent.com/aida-public/AB6AXuBvd6mKNPtZ9uI766XKI55wPk-fNTuTlHlmth4CIs_6IesHGu32drHgJC8ORwsuxHEGbZDgtVrI2Rp1yGr_BgqC4Ahk-oxd4cT8aFHjnzlB_ljG4xz4CYKY9Xupq-rYXOevIH4sSxeOVqdu9vw1TOsrvtssv7qbxOfSz-Kg_r4QrdJUS0s4BvqZHt4ObafMi-8TEDg7PWg-pMwgCnri2g2cw-RwPYsO6Zvz8w_BZ304orFYTFwbc6Be8iikfYHycKCPlTTTZuN6IyZJ",
                            ),
                            fit: BoxFit.cover,
                            opacity: 0.4,
                          ),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                emeraldDeep,
                                Color(0x66062C1E),
                                Colors.transparent,
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // 🚀 Continue Button
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: limeGlow,
                            foregroundColor: emeraldDeep,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            shadowColor: limeGlow.withOpacity(0.35),
                            elevation: 15,
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const KrishiAILoginScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "CONTINUE",
                                style: GoogleFonts.spaceGrotesk(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Optimized for night-time use",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 🔸 Bottom Indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 128,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const emeraldDeep = Color(0xFF062C1E);
    const charcoalDark = Color(0xFF1A1C1A);
    const limeGlow = Color(0xFFBCFF00);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: charcoalDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? limeGlow.withOpacity(0.8)
                : const Color(0xFF064E3B).withOpacity(0.5),
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: limeGlow.withOpacity(0.35), blurRadius: 20)]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? limeGlow
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? emeraldDeep
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(
                        color: isSelected
                            ? limeGlow
                            : Colors.white.withOpacity(0.3),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.spaceGrotesk(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.8),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 28 : 24,
              height: isSelected ? 28 : 24,
              decoration: BoxDecoration(
                color: isSelected ? limeGlow : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
                border: isSelected
                    ? null
                    : Border.all(
                        color: const Color(0xFF064E3B).withOpacity(0.5),
                        width: 2,
                      ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: emeraldDeep, size: 18)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

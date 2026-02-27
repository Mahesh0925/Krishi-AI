import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_ai/View/language_screen.dart';

class KrishiAISplashScreen extends StatefulWidget {
  const KrishiAISplashScreen({super.key});

  @override
  State<KrishiAISplashScreen> createState() => _KrishiAISplashScreenState();
}

class _KrishiAISplashScreenState extends State<KrishiAISplashScreen> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (progress >= 1.0) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 800),
              pageBuilder: (_, _, _) => const KrishiLanguageScreen(),
              transitionsBuilder: (_, animation, _, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          );
        });
      } else {
        setState(() => progress += 0.01);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF061506),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [Color(0xFF143A14), Color(0xFF061506)],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: const Color(0xFFB4F42C).withOpacity(0.05),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: const Color(0xFFB4F42C).withOpacity(0.05),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🌿 Icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A240A).withOpacity(0.8),
                        border: Border.all(
                          color: const Color(0xFFB4F42C).withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 50,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_florist,
                        color: Color(0xFFB4F42C),
                        size: 70,
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB4F42C),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFB4F42C).withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.query_stats,
                          color: Color(0xFF061506),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // ✨ Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Krishi",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "AI",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB4F42C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 1,
                      color: const Color(0xFFB4F42C).withOpacity(0.3),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "SMART FARMING ASSISTANT",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        letterSpacing: 2,
                        color: const Color(0xFFB4F42C).withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 24,
                      height: 1,
                      color: const Color(0xFFB4F42C).withOpacity(0.3),
                    ),
                  ],
                ),
                const SizedBox(height: 60),

                // 🌾 Animated Progress
                SizedBox(
                  width: 260,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Container(
                              height: 4,
                              color: Colors.white.withOpacity(0.05),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              height: 4,
                              width: 260 * progress,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFB4F42C).withOpacity(0.4),
                                    const Color(0xFFB4F42C),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFB4F42C,
                                    ).withOpacity(0.4),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "SYSTEM LOAD",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.4),
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            "${(progress * 100).toInt()}%",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFB4F42C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Opacity(
                        opacity: 0.6,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.verified_user,
                                  color: Color(0xFFB4F42C),
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "SECURE NEURAL LINK",
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 11,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "v5.0.1",
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.3),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFB4F42C,
                                    ).withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Dark Mode Active",
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.3),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: Container(
              width: 200,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

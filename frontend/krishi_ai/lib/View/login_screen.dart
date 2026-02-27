import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_ai/View/home_screen.dart';
import 'package:krishi_ai/View/language_screen.dart';
import 'package:krishi_ai/View/signup_screen.dart';

class KrishiAILoginScreen extends StatefulWidget {
  const KrishiAILoginScreen({super.key});

  @override
  State<KrishiAILoginScreen> createState() => _KrishiAILoginScreenState();
}

class _KrishiAILoginScreenState extends State<KrishiAILoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF59F20D);
    const Color backgroundDark = Color(0xFF162210);
    const Color surfaceDark = Color(0xFF1E2923);

    final size = MediaQuery.of(context).size;
    final double maxWidth = size.width > 480 ? 420 : size.width * 0.9;

    return WillPopScope(
      onWillPop: () async {
        // ✅ Go back to language screen instead of closing app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const KrishiLanguageScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundDark,
        body: Stack(
          children: [
            // 🌿 Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [backgroundDark, surfaceDark],
                ),
              ),
            ),

            // 💚 Glow effects
            Positioned(
              top: -100,
              left: -100,
              child: _blurCircle(primary.withOpacity(0.1), 220),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: _blurCircle(primary.withOpacity(0.08), 260),
            ),

            // 🌾 Login content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🌱 Logo
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.2),
                        border: Border.all(color: primary.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: Icon(Icons.eco, color: primary, size: 48),
                    ),
                    const SizedBox(height: 28),

                    // 👋 Welcome texts
                    Text(
                      "Welcome Back",
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Login to continue your harvest",
                      style: GoogleFonts.spaceGrotesk(
                        color: primary.withOpacity(0.7),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // 🧾 Form fields
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("Mobile or Email", primary),
                          const SizedBox(height: 8),
                          _inputField(
                            icon: Icons.person_outline,
                            hint: "Enter mobile or email",
                            primary: primary,
                            fill: surfaceDark,
                          ),
                          const SizedBox(height: 22),
                          _label("Password", primary),
                          const SizedBox(height: 8),
                          _inputField(
                            icon: Icons.lock_outline,
                            hint: "Enter your password",
                            primary: primary,
                            fill: surfaceDark,
                            obscure: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: primary.withOpacity(0.5),
                              ),
                              onPressed: () {
                                setState(
                                  () =>
                                      _isPasswordVisible = !_isPasswordVisible,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.spaceGrotesk(
                                  color: primary.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 🔘 Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const KrishiAIDashboard(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                shape: const StadiumBorder(),
                                shadowColor: primary.withOpacity(0.4),
                                elevation: 10,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Login",
                                    style: GoogleFonts.spaceGrotesk(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.1),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  "OR",
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white.withOpacity(0.3),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.1),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Footer
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KrishiAISignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.spaceGrotesk(
                          color: primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Subtle watermark
                    Opacity(
                      opacity: 0.05,
                      child: Text(
                        "KRISHI AI",
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🌾 Helper widgets
  Widget _blurCircle(Color color, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 60)],
    ),
  );

  Widget _label(String text, Color color) => Text(
    text,
    style: GoogleFonts.spaceGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color.withOpacity(0.6),
    ),
  );

  Widget _inputField({
    required IconData icon,
    required String hint,
    required Color primary,
    required Color fill,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      obscureText: obscure,
      style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primary.withOpacity(0.4)),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: GoogleFonts.spaceGrotesk(
          color: Colors.white.withOpacity(0.3),
          fontSize: 16,
        ),
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: primary.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: primary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }
}

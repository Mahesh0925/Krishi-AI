import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_ai/View/home_screen.dart';
import 'package:krishi_ai/View/language_screen.dart';
import 'package:krishi_ai/View/signup_screen.dart';

// Optional: import your CustomSnackbar & Currentuser if already built
// import 'package:krishi_ai/utils/custom_snackbar.dart';
// import 'package:krishi_ai/services/current_user.dart';

class KrishiAILoginScreen extends StatefulWidget {
  const KrishiAILoginScreen({super.key});

  @override
  State<KrishiAILoginScreen> createState() => _KrishiAILoginScreenState();
}

class _KrishiAILoginScreenState extends State<KrishiAILoginScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF59F20D);
    const Color backgroundDark = Color(0xFF162210);
    const Color surfaceDark = Color(0xFF1E2923);

    final size = MediaQuery.of(context).size;
    final double maxWidth = size.width > 480 ? 420 : size.width * 0.9;

    return WillPopScope(
      onWillPop: () async {
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
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [backgroundDark, surfaceDark],
                ),
              ),
            ),
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
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    Text(
                      "welcome_back".tr,
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "login_continue".tr,
                      style: GoogleFonts.spaceGrotesk(
                        color: primary.withValues(alpha: 0.7),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // 🧾 Login form
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("email".tr, primary),
                          const SizedBox(height: 8),
                          _inputField(
                            controller: emailController,
                            icon: Icons.person_outline,
                            hint: "enter_email".tr,
                            primary: primary,
                            fill: surfaceDark,
                          ),
                          const SizedBox(height: 22),
                          _label("password".tr, primary),
                          const SizedBox(height: 8),
                          _inputField(
                            controller: passwordController,
                            icon: Icons.lock_outline,
                            hint: "enter_password".tr,
                            primary: primary,
                            fill: surfaceDark,
                            obscure: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: primary.withValues(alpha: 0.5),
                              ),
                              onPressed: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "forgot_password".tr,
                                style: GoogleFonts.spaceGrotesk(
                                  color: primary.withValues(alpha: 0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 🚀 Login button with Firebase Auth
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: GestureDetector(
                              onTap: () async {
                                if (emailController.text.trim().isNotEmpty &&
                                    passwordController.text.trim().isNotEmpty) {
                                  setState(() => _isLoading = true);
                                  try {
                                    UserCredential userCredentialObj =
                                        await _firebaseAuth
                                            .signInWithEmailAndPassword(
                                              email: emailController.text
                                                  .trim(),
                                              password: passwordController.text
                                                  .trim(),
                                            );

                                    // CustomSnackbar().showCustomSnackbar(context, "Login Successful !", bgColor: Colors.green);
                                    _showSnackbar(
                                      context,
                                      "login_successful".tr,
                                      Colors.green,
                                    );

                                    // Currentuser.saveUserData(emailController.text);
                                    emailController.clear();
                                    passwordController.clear();

                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const KrishiAIDashboard(),
                                      ),
                                    );
                                  } on FirebaseAuthException catch (error) {
                                    _showSnackbar(
                                      context,
                                      error.message ?? "login_failed".tr,
                                      const Color.fromARGB(189, 244, 27, 27),
                                    );
                                  } finally {
                                    setState(() => _isLoading = false);
                                  }
                                } else {
                                  _showSnackbar(
                                    context,
                                    "enter_valid_credentials".tr,
                                    const Color.fromARGB(189, 244, 27, 27),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.black,
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "login".tr,
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
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "dont_have_account".tr,
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white.withValues(alpha: 0.5),
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
                        "sign_up".tr,
                        style: GoogleFonts.spaceGrotesk(
                          color: primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
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

  // 🔔 Local snackbar helper
  void _showSnackbar(BuildContext context, String msg, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // 🌿 UI helpers
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
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required Color primary,
    required Color fill,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
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

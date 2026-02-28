import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KrishiAISignUpScreen extends StatefulWidget {
  const KrishiAISignUpScreen({super.key});

  @override
  State<KrishiAISignUpScreen> createState() => _KrishiAISignUpScreenState();
}

class _KrishiAISignUpScreenState extends State<KrishiAISignUpScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // ✏️ Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF93F20D);
    const Color backgroundDark = Color(0xFF0E1408);
    const Color surfaceDark = Color(0xFF1B2310);
    const Color borderDark = Color(0xFF2D3A1A);

    final size = MediaQuery.of(context).size;
    final double maxWidth = size.width > 480 ? 420 : size.width * 0.9;

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Container(
            width: maxWidth,
            decoration: BoxDecoration(
              color: backgroundDark,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                _logo(primary, surfaceDark),
                const SizedBox(height: 20),
                Text(
                  "create_account".tr,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "join_smart_farming".tr,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 32),

                _sectionTitle("personal_information".tr, primary),
                const SizedBox(height: 12),

                // 🧾 Inputs with controllers
                _textInput(
                  "full_name".tr,
                  "eg_name".tr,
                  Icons.person,
                  nameController,
                  primary,
                  surfaceDark,
                  borderDark,
                ),
                const SizedBox(height: 18),
                _textInput(
                  "mobile_number".tr,
                  "phone_placeholder".tr,
                  Icons.call,
                  mobileController,
                  primary,
                  surfaceDark,
                  borderDark,
                ),
                const SizedBox(height: 18),
                _textInput(
                  "email_address".tr,
                  "email_placeholder".tr,
                  Icons.mail,
                  emailController,
                  primary,
                  surfaceDark,
                  borderDark,
                ),
                const SizedBox(height: 18),
                _passwordField(
                  "create_password".tr,
                  passwordController,
                  primary,
                  surfaceDark,
                  borderDark,
                ),

                const SizedBox(height: 30),
                Divider(color: borderDark.withValues(alpha: 0.5), thickness: 1),
                const SizedBox(height: 18),
                _sectionTitle("farm_information".tr, primary),

                const SizedBox(height: 32),
                // 🚀 Firebase Signup Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: backgroundDark,
                      shape: const StadiumBorder(),
                      shadowColor: primary.withValues(alpha: 0.3),
                      elevation: 12,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "create_my_account".tr,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: backgroundDark,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: backgroundDark,
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 30),
                Text(
                  "already_have_account".tr,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "log_in".tr,
                    style: GoogleFonts.spaceGrotesk(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🚀 Firebase SignUp logic
  Future<void> _handleSignUp() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      _showSnackbar("enter_valid_data".tr, Colors.red);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      _showSnackbar("signup_successful".tr, Colors.lightGreen);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (error) {
      _showSnackbar(error.message ?? "error".tr, Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // 🧩 UI Helpers below

  Widget _logo(Color primary, Color surfaceDark) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: primary.withValues(alpha: 0.5)),
          ),
          child: Icon(Icons.eco, color: primary, size: 40),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Krishi",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "AI",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 24,
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, Color primary) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      title.toUpperCase(),
      style: GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: primary.withValues(alpha: 0.7),
        letterSpacing: 2,
      ),
    ),
  );

  Widget _textInput(
    String label,
    String hint,
    IconData icon,
    TextEditingController controller,
    Color primary,
    Color fill,
    Color border,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.4)),
            hintText: hint,
            hintStyle: GoogleFonts.spaceGrotesk(
              color: Colors.white.withValues(alpha: 0.25),
            ),
            filled: true,
            fillColor: fill,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: primary, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordField(
    String label,
    TextEditingController controller,
    Color primary,
    Color fill,
    Color border,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: !_isPasswordVisible,
          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.white.withValues(alpha: 0.4),
            ),
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
            hintText: "••••••••",
            hintStyle: GoogleFonts.spaceGrotesk(
              color: Colors.white.withValues(alpha: 0.25),
            ),
            filled: true,
            fillColor: fill,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: primary, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

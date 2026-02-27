import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KrishiAISignUpScreen extends StatefulWidget {
  const KrishiAISignUpScreen({super.key});

  @override
  State<KrishiAISignUpScreen> createState() => _KrishiAISignUpScreenState();
}

class _KrishiAISignUpScreenState extends State<KrishiAISignUpScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    // 🎨 color palette
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
                // 🌱 header logo
                const SizedBox(height: 24),
                _logo(primary, surfaceDark),
                const SizedBox(height: 20),
                Text(
                  "Create Account",
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Join the future of smart farming.",
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 32),

                // 🧾 Form section
                _sectionTitle("Personal Information", primary),
                const SizedBox(height: 12),
                _textInput(
                  "Full Name",
                  "e.g. Rahul Sharma",
                  Icons.person,
                  primary,
                  surfaceDark,
                  borderDark,
                ),
                const SizedBox(height: 18),
                _textInput(
                  "Mobile Number",
                  "+91 00000 00000",
                  Icons.call,
                  primary,
                  surfaceDark,
                  borderDark,
                ),
                const SizedBox(height: 18),
                _textInput(
                  "Email Address",
                  "name@example.com",
                  Icons.mail,
                  primary,
                  surfaceDark,
                  borderDark,
                ),
                const SizedBox(height: 18),
                _passwordField(
                  "Create Password",
                  primary,
                  surfaceDark,
                  borderDark,
                ),

                const SizedBox(height: 30),
                Divider(color: borderDark.withOpacity(0.5), thickness: 1),
                const SizedBox(height: 18),
                _sectionTitle("Farm Information", primary),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _dropdown(
                        "Primary Crop",
                        ["Rice", "Wheat", "Cotton", "Corn"],
                        primary,
                        surfaceDark,
                        borderDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dropdown(
                        "State",
                        ["Punjab", "Haryana", "Maharashtra", "Gujarat"],
                        primary,
                        surfaceDark,
                        borderDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _textInput(
                  "Farm Size (Acres)",
                  "Enter acreage",
                  Icons.spa,
                  primary,
                  surfaceDark,
                  borderDark,
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text.rich(
                    TextSpan(
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                      ),
                      children: [
                        const TextSpan(
                          text: "By signing up, you agree to our ",
                        ),
                        TextSpan(
                          text: "Terms of Service",
                          style: const TextStyle(
                            color: primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: " and "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: const TextStyle(
                            color: primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: "."),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24),
                // 🚀 Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: backgroundDark,
                      shape: const StadiumBorder(),
                      shadowColor: primary.withOpacity(0.3),
                      elevation: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Create My Account",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: backgroundDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, color: backgroundDark),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Divider
                // Row(
                //   children: [
                //     Expanded(child: Container(height: 1, color: borderDark)),
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 10),
                //       child: Text(
                //         "or sign up with",
                //         style: GoogleFonts.spaceGrotesk(
                //           color: Colors.white.withOpacity(0.3),
                //           fontSize: 12,
                //           letterSpacing: 1.5,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //     Expanded(child: Container(height: 1, color: borderDark)),
                //   ],
                // ),
                // const SizedBox(height: 20),

                // // 🌐 Google login
                // SizedBox(
                //   width: double.infinity,
                //   height: 56,
                //   child: OutlinedButton.icon(
                //     onPressed: () {},
                //     icon: const Icon(
                //       Icons.g_mobiledata,
                //       color: Colors.white,
                //       size: 32,
                //     ),
                //     label: Text(
                //       "Continue with Google",
                //       style: GoogleFonts.spaceGrotesk(
                //         color: Colors.white,
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //     style: OutlinedButton.styleFrom(
                //       side: BorderSide(color: borderDark),
                //       shape: const StadiumBorder(),
                //       backgroundColor: Colors.transparent,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 30),
                Text(
                  "Already have an account?",
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Log In",
                    style: GoogleFonts.spaceGrotesk(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🧩 Components
  Widget _logo(Color primary, Color surfaceDark) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: primary.withOpacity(0.5)),
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

  Widget _sectionTitle(String title, Color primary) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.spaceGrotesk(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: primary.withOpacity(0.7),
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _textInput(
    String label,
    String hint,
    IconData icon,
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
          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.4)),
            hintText: hint,
            hintStyle: GoogleFonts.spaceGrotesk(
              color: Colors.white.withOpacity(0.25),
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

  Widget _passwordField(String label, Color primary, Color fill, Color border) {
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
          obscureText: !_isPasswordVisible,
          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: Colors.white.withOpacity(0.4)),
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
            hintText: "••••••••",
            hintStyle: GoogleFonts.spaceGrotesk(
              color: Colors.white.withOpacity(0.25),
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

  Widget _dropdown(
    String label,
    List<String> items,
    Color primary,
    Color fill,
    Color border,
  ) {
    String? selected;
    return StatefulBuilder(
      builder: (context, setState) {
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: fill,
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(50),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: fill,
                  value: selected,
                  hint: Text(
                    "Select",
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  icon: Icon(
                    Icons.expand_more,
                    color: Colors.white.withOpacity(0.4),
                  ),
                  isExpanded: true,
                  items: items
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() => selected = val);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

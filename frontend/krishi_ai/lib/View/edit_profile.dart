import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class KrishiAIFarmerProfile extends StatelessWidget {
  const KrishiAIFarmerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    const Color primary = Color(0xFF59F20D);
    const Color backgroundDark = Color(0xFF162210);
    const Color surfaceDark = Color(0xFF1E2923);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        title: Text(
          "My Profile".tr,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 👤 Profile Avatar
            Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: primary,
                      child: const CircleAvatar(
                        radius: 51,
                        backgroundImage: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBKb3I9fm3genTuC5RZUt-UPpXUCUFX5f_zLfP3rmiveMfOWgTJJp0PDZpgLIx0IrmHr1dLcS4KQfEMjUZzjeanoTcWbWEOruNUQEyPsPKOgIKk9cXususzkoH4-UfiNcnbn_IsKZmte-f83O8-Zub_l4bWhdcGn-waDHnP2fAdfdXAR78IusD8-cKCZ997hnDxBRwJiR-16QPOEQAJOmxzp0IQBXzGHKKesCEB1koVzY2rkT_cKqY6RbQVeiQF9TncIrce4ekOo6Uq',
                        ),
                      ),
                    ),
                    Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: backgroundDark, width: 3),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Mauli',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '1234567890'.tr,
                  style: GoogleFonts.inter(
                    color: primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 🧾 Personal Info
            _buildCard(
              title: "personal_info".tr,
              children: [
                _buildInputField(
                  "full_name".tr,
                  "Mauli",
                  backgroundDark,
                  primary,
                ),
                _buildInputField(
                  "phone_number".tr,
                  "+91 1234567890",
                  backgroundDark,
                  primary,
                ),
                _buildInputField(
                  "email_address".tr,
                  "mauli@gmail.com",
                  backgroundDark,
                  primary,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🌾 Farming Details
            _buildCard(
              title: "farming_details".tr,
              children: [
                _buildDropdownField(
                  "primary_crop".tr,
                  ["Rice", "Wheat", "Corn", "Cotton"],
                  "Wheat",
                  backgroundDark,
                  primary,
                ),
                _buildInputField(
                  "farm_size".tr,
                  "12",
                  backgroundDark,
                  primary,
                  keyboardType: TextInputType.number,
                ),
                _buildLocationField("location".tr, backgroundDark, primary),
              ],
            ),

            const SizedBox(height: 30),

            // 💾 Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: backgroundDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                  shadowColor: primary.withOpacity(0.3),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Changes Saved..!".tr),
                      backgroundColor: primary.withOpacity(0.8),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Save Changes".tr,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // 🌿 Card Container
  Widget _buildCard({required String title, required List<Widget> children}) {
    const Color surfaceDark = Color(0xFF1E2923);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.inter(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  // ✏️ Input Field
  Widget _buildInputField(
    String label,
    String value,
    Color bg,
    Color primary, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: value,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: bg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🌾 Dropdown Field
  Widget _buildDropdownField(
    String label,
    List<String> items,
    String selected,
    Color bg,
    Color primary,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selected,
                dropdownColor: bg,
                icon: Icon(Icons.keyboard_arrow_down, color: primary),
                isExpanded: true,
                style: const TextStyle(color: Colors.white),
                items: items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 📍 Location Field
  Widget _buildLocationField(String label, Color bg, Color primary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: 'Lonavala, India',
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: bg,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary.withOpacity(0.2)),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.my_location, color: primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

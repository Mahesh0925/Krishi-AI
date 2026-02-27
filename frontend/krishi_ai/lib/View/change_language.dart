import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  int selectedIndex = -1; // none selected initially

  static const Color primary = Color(0xFF59F20D);
  static const Color surfaceDark = Color(0xFF1E2923);
  static const Color backgroundDark = Color(0xFF162210);

  final languages = <Map<String, String>>[
    {'icon': 'A', 'title': 'English', 'subtitle': 'Active'},
    {'icon': 'हि', 'title': 'हिन्दी', 'subtitle': 'Hindi'},
    {'icon': 'म', 'title': 'मराठी', 'subtitle': 'Marathi'},
  ];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenW = mq.size.width;
    final screenH = mq.size.height;

    final basePadding = screenW * 0.05;
    final avatarSize = (screenW * 0.20).clamp(56.0, 110.0);
    final tileHeight = (screenH * 0.09).clamp(64.0, 92.0);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: basePadding, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              // 🌍 Translate icon
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.translate_rounded,
                    color: primary,
                    size: avatarSize * 0.45,
                  ),
                ),
              ),

              SizedBox(height: screenH * 0.03),

              const Text(
                'Select Language',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Choose your preferred language to continue using Krishi AI',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenH * 0.04),

              // 🟢 Language Buttons
              Column(
                children: List.generate(languages.length, (i) {
                  final lang = languages[i];
                  final isActive = selectedIndex == i;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Material(
                      color: surfaceDark,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => setState(() => selectedIndex = i),
                        child: Container(
                          height: tileHeight,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isActive ? primary : Colors.white10,
                              width: isActive ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: tileHeight * 0.65,
                                    height: tileHeight * 0.65,
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? primary.withValues(alpha: 0.20)
                                          : Colors.white10,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      lang['icon'] ?? '',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: isActive
                                            ? primary
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        lang['title'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        lang['subtitle'] ?? '',
                                        style: TextStyle(
                                          color: isActive
                                              ? primary.withValues(alpha: 0.8)
                                              : Colors.grey.shade500,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (isActive)
                                Container(
                                  width: tileHeight * 0.35,
                                  height: tileHeight * 0.35,
                                  decoration: const BoxDecoration(
                                    color: primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: surfaceDark,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: screenH * 0.05),

              // Change Language Button — visible only when a language is selected
              if (selectedIndex != -1)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // ✅ Pop this page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: primary.withOpacity(0.4),
                    ),
                    child: const Text(
                      "CHANGE LANGUAGE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 40),

              Text(
                'You can change this anytime in Profile settings',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

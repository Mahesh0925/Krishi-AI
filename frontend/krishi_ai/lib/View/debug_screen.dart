import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DebugScreen extends StatelessWidget {
  final File imageFile;
  final Map<String, dynamic> analysisResult;

  const DebugScreen({
    super.key,
    required this.imageFile,
    required this.analysisResult,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF59F20D);
    const backgroundDark = Color(0xFF0A0F08);
    const surfaceDark = Color(0xFF162210);

    final allPredictions =
        analysisResult['all_predictions'] as Map<String, String>? ?? {};

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
          "Model Debug Info",
          style: GoogleFonts.spaceGrotesk(
            color: primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primary.withValues(alpha: 0.25)),
                image: DecorationImage(
                  image: FileImage(imageFile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Top Prediction
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primary.withValues(alpha: 0.18)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Top Prediction",
                    style: GoogleFonts.spaceGrotesk(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${analysisResult['label']} (${analysisResult['confidence']}%)",
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  if (analysisResult['raw_confidence'] != null)
                    Text(
                      "Raw confidence: ${analysisResult['raw_confidence']}",
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // All Predictions
            Text(
              "All Model Predictions",
              style: GoogleFonts.spaceGrotesk(
                color: primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            ...allPredictions.entries.map((entry) {
              final confidence = double.tryParse(entry.value) ?? 0.0;
              final isTopPrediction = entry.key == analysisResult['label'];

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isTopPrediction
                      ? primary.withValues(alpha: 0.15)
                      : surfaceDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isTopPrediction
                        ? primary.withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key.replaceAll('_', ' '),
                        style: GoogleFonts.spaceGrotesk(
                          color: isTopPrediction ? primary : Colors.white,
                          fontSize: 12,
                          fontWeight: isTopPrediction
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: confidence / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isTopPrediction ? primary : Colors.grey[600],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${entry.value}%",
                      style: GoogleFonts.spaceGrotesk(
                        color: isTopPrediction ? primary : Colors.grey[400],
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            // Model Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Model Information",
                    style: GoogleFonts.spaceGrotesk(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "• Input Size: 224x224x3\n"
                    "• Normalization: [0, 1]\n"
                    "• Total Classes: ${allPredictions.length}\n"
                    "• Model Type: TensorFlow Lite",
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.18)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        "Debugging Tips",
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "• Check if the top prediction matches your expected result\n"
                    "• Look at confidence scores - low scores may indicate preprocessing issues\n"
                    "• If all predictions are similar, the model might need different normalization\n"
                    "• Check console logs for detailed model input/output information",
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

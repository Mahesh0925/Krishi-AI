import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:krishi_ai/View/detection_screen.dart';
import 'package:krishi_ai/services/crop_detection_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final Color primary = const Color(0xFF59F20D);
  final Color backgroundDark = const Color(0xFF0A0F08);

  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _showOptions = true;

  @override
  void initState() {
    super.initState();
    // Initialize the crop detection service
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    try {
      await CropDetectionService.initialize();
    } catch (e) {
      print('Failed to initialize model: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load AI model: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _openCamera();
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        _showPermissionDialog();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Camera permission is required")),
        );
        Navigator.pop(context);
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2923),
        title: Text(
          "Camera Permission Required",
          style: GoogleFonts.spaceGrotesk(color: Colors.white),
        ),
        content: Text(
          "Please enable camera permission in settings to scan crop diseases.",
          style: GoogleFonts.spaceGrotesk(color: Colors.grey[400]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: Text("Open Settings", style: TextStyle(color: primary)),
          ),
        ],
      ),
    );
  }

  Future<void> _openCamera() async {
    try {
      print('=== CAMERA: Opening camera ===');
      setState(() => _showOptions = false);

      final XFile? xfile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 2000,
      );

      if (xfile == null) {
        print('=== CAMERA: No image selected ===');
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      }

      final File file = File(xfile.path);
      print('=== CAMERA: Image captured ===');
      print('File path: ${file.path}');
      print('File exists: ${await file.exists()}');
      print('File size: ${await file.length()} bytes');

      setState(() => _isLoading = true);

      final analysis = await _analyzeImage(file);

      if (!mounted) return;
      setState(() => _isLoading = false);

      print('=== CAMERA: Navigating to result screen ===');
      print('Analysis data: $analysis');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            imageFile: file,
            diseaseName: analysis["diseaseName"],
            confidence: analysis["confidence"],
            treatment: analysis["treatment"],
            dosage: analysis["dosage"],
            prevention: analysis["prevention"],
            isHealthy: analysis["isHealthy"],
            label: analysis["label"],
            allPredictions: analysis["all_predictions"] as Map<String, String>?,
          ),
        ),
      );
    } catch (e, stackTrace) {
      print('=== CAMERA: Error in _openCamera ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Camera Error: $e")));
        Navigator.pop(context);
      }
    }
  }

  Future<void> _openGallery() async {
    try {
      setState(() => _showOptions = false);

      final XFile? xfile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 2000,
      );

      if (xfile == null) {
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      }

      final File file = File(xfile.path);
      setState(() => _isLoading = true);

      final analysis = await _analyzeImage(file);

      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            imageFile: file,
            diseaseName: analysis["diseaseName"],
            confidence: analysis["confidence"],
            treatment: analysis["treatment"],
            dosage: analysis["dosage"],
            prevention: analysis["prevention"],
            isHealthy: analysis["isHealthy"],
            label: analysis["label"],
            allPredictions: analysis["all_predictions"] as Map<String, String>?,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gallery Error: $e")));
        Navigator.pop(context);
      }
    }
  }

  // Real AI analysis using TensorFlow Lite model
  Future<Map<String, dynamic>> _analyzeImage(File image) async {
    try {
      print('=== CAMERA SCREEN: Starting disease detection ===');
      print('Image path: ${image.path}');

      final result = await CropDetectionService.detectDisease(image);

      print('=== CAMERA SCREEN: Detection result received ===');
      print('Result type: ${result.runtimeType}');
      print('Result keys: ${result.keys.toList()}');
      print('Full result: $result');

      // Validate result has required fields
      if (!result.containsKey('disease_name') ||
          !result.containsKey('treatment')) {
        throw Exception('Result missing required fields: $result');
      }

      final mappedResult = {
        "diseaseName": result['disease_name'],
        "confidence": "${result['confidence']}%",
        "treatment": result['treatment'],
        "dosage": result['dosage'],
        "prevention": result['prevention'],
        "isHealthy": result['is_healthy'],
        "label": result['label'],
      };

      print('=== CAMERA SCREEN: Mapped result for UI ===');
      print('Mapped result: $mappedResult');
      print('Disease name being passed: ${mappedResult["diseaseName"]}');
      print('Treatment being passed: ${mappedResult["treatment"]}');

      return mappedResult;
    } catch (e, stackTrace) {
      print('=== CAMERA SCREEN: Analysis error ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      // Fallback to mock data if model fails
      final fallbackResult = {
        "diseaseName": "Analysis Failed",
        "confidence": "0%",
        "treatment":
            "Unable to analyze image. Please try again with a clearer photo of the crop leaf.",
        "dosage": "Not available",
        "prevention": "Ensure good lighting and focus when taking photos.",
        "isHealthy": false,
        "label": "unknown",
      };

      print('Returning fallback result: $fallbackResult');
      return fallbackResult;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: backgroundDark,
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E2923),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Scan Crop Disease",
            style: GoogleFonts.spaceGrotesk(
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(
          children: [
            if (_showOptions)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_rounded, color: primary, size: 80),
                    const SizedBox(height: 30),
                    Text(
                      "Choose an option",
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildOptionButton(
                      icon: Icons.camera_alt,
                      label: "Take Photo",
                      onTap: _requestCameraPermission,
                    ),
                    const SizedBox(height: 16),
                    _buildOptionButton(
                      icon: Icons.photo_library,
                      label: "Choose from Gallery",
                      onTap: _openGallery,
                    ),
                  ],
                ),
              ),
            if (_isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.85),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: primary, strokeWidth: 4),
                      const SizedBox(height: 20),
                      Text(
                        "Analyzing Crop Disease...",
                        style: GoogleFonts.spaceGrotesk(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2923),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primary, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

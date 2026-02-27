import 'package:flutter/material.dart';
import 'package:krishi_ai/View/spalsh_screen.dart';
import 'package:krishi_ai/services/crop_detection_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the crop detection service
  try {
    await CropDetectionService.initialize();
    print('Crop detection model loaded successfully');
  } catch (e) {
    print('Failed to load crop detection model: $e');
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KrishiAISplashScreen(),
    );
  }
}

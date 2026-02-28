import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:krishi_ai/View/spalsh_screen.dart';
import 'package:krishi_ai/services/crop_detection_service.dart';
import 'package:logger/logger.dart';

final logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ✅ Initialize Firebase
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAwwyAWtZhyXbzomqhpT9Reqbg-R4DMJ8s",
        appId: "1:1009501531964:android:b25ba169bbd6560e3ab839",
        messagingSenderId: "1009501531964",
        projectId: "krishi-ai-bd03a",
      ),
    );
    logger.i('✅ Firebase initialized successfully');
  } catch (e) {
    logger.e('❌ Firebase initialization failed: $e');
  }

  // Initialize the crop detection service
  try {
    await CropDetectionService.initialize();
    logger.i('🌾 Crop detection model loaded successfully');
  } catch (e) {
    logger.e('🚫 Failed to load crop detection model: $e');
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

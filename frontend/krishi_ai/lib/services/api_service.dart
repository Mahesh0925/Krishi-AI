import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Change this to your backend URL
  // For local testing: http://10.0.2.2:8000 (Android emulator)
  // For local testing: http://localhost:8000 (iOS simulator)
  // For production: https://your-backend-url.com
  static const String baseUrl = 'http://10.0.2.2:8000';

  /// Detect crop disease from image
  static Future<Map<String, dynamic>> detectDisease(
    File imageFile, {
    bool useGemini = true,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/detect-disease?use_gemini=$useGemini'),
      );

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to detect disease: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  /// Chat with AI assistant
  static Future<Map<String, dynamic>> chat(
    String message, {
    String? context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message, 'context': context}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Chat failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  /// Get treatment details for a disease
  static Future<Map<String, dynamic>> getTreatment(String diseaseName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/get-treatment?disease_name=$diseaseName'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get treatment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  /// Check backend health
  static Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

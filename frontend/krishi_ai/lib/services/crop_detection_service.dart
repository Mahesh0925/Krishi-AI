import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CropDetectionService {
  static const String backendUrl =
      'https://mor-backend-4i9u.onrender.com/detect-disease';
  static Interpreter? _interpreter;
  static List<String>? _labels;
  static Map<String, dynamic>? _diseaseInfo;

  // Initialize the model and load labels - matching Python implementation
  static Future<void> initialize() async {
    try {
      // Load the TensorFlow Lite model
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');

      // Get model input/output details for debugging
      final inputTensors = _interpreter!.getInputTensors();
      final outputTensors = _interpreter!.getOutputTensors();

      print('Model Input Shape: ${inputTensors[0].shape}');
      print('Model Input Type: ${inputTensors[0].type}');
      print('Model Output Shape: ${outputTensors[0].shape}');
      print('Model Output Type: ${outputTensors[0].type}');

      // Load labels - matching Python: labels = f.read().splitlines()
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData
          .split('\n')
          .where((label) => label.trim().isNotEmpty)
          .map((label) => label.trim())
          .toList();

      // Load disease information
      final diseaseInfoData = await rootBundle.loadString(
        'assets/disease_info.json',
      );
      _diseaseInfo = json.decode(diseaseInfoData);

      print('Model initialized successfully');
      print('Labels loaded: ${_labels?.length}');
      print('Labels: $_labels');
    } catch (e) {
      print('Error initializing model: $e');
      throw Exception('Failed to initialize crop detection model: $e');
    }
  }

  // Preprocess image exactly like Python implementation
  static Float32List _preprocessImage(File imageFile) {
    try {
      // Read and decode image
      final bytes = imageFile.readAsBytesSync();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      print('Original image size: ${image.width}x${image.height}');

      // Python: Image.open("test.jpeg").resize((224, 224))
      image = img.copyResize(image, width: 224, height: 224);
      print('Resized image to: ${image.width}x${image.height}');

      // Python: img = np.array(img).astype(np.float32)
      // Python: img = np.expand_dims(img, axis=0)
      // NO normalization - keep pixel values in 0-255 range!
      final input = Float32List(224 * 224 * 3);
      int pixelIndex = 0;

      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          final pixel = image.getPixel(x, y);

          // Direct pixel values as float32 (0-255 range) - exactly like Python
          input[pixelIndex++] = pixel.r.toDouble();
          input[pixelIndex++] = pixel.g.toDouble();
          input[pixelIndex++] = pixel.b.toDouble();
        }
      }

      print('Preprocessed input tensor size: ${input.length}');
      print('Sample pixel values (0-255 range): ${input.take(9).toList()}');
      print('Min pixel value: ${input.reduce(math.min)}');
      print('Max pixel value: ${input.reduce(math.max)}');

      return input;
    } catch (e) {
      print('Error preprocessing image: $e');
      throw Exception('Failed to preprocess image: $e');
    }
  }

  // Run inference exactly like Python implementation
  static Future<Map<String, dynamic>> detectDisease(File imageFile) async {
    // First, try the deployed backend API
    try {
      print('=== STARTING DISEASE DETECTION ===');
      print('Attempting to use backend API...');
      final result = await _detectDiseaseFromBackend(imageFile);
      print('=== BACKEND API SUCCEEDED ===');
      print('Final result being returned: $result');
      return result;
    } catch (e, stackTrace) {
      print('=== BACKEND API FAILED ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      print('Falling back to local TFLite model...');
    }

    // Fallback to local TFLite model
    print('=== USING LOCAL MODEL ===');
    return await _detectDiseaseFromModel(imageFile);
  }

  // Detect disease using deployed backend API
  static Future<Map<String, dynamic>> _detectDiseaseFromBackend(
    File imageFile,
  ) async {
    http.Client? client;
    try {
      // Create a fresh client for each request to avoid connection reuse issues
      client = http.Client();

      var request = http.MultipartRequest('POST', Uri.parse(backendUrl));

      // Read file bytes and determine content type
      final bytes = await imageFile.readAsBytes();
      final filename = imageFile.path.split('/').last;

      // Determine mime type from file extension
      String contentType = 'image/jpeg';
      if (filename.toLowerCase().endsWith('.png')) {
        contentType = 'image/png';
      } else if (filename.toLowerCase().endsWith('.jpg') ||
          filename.toLowerCase().endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      } else if (filename.toLowerCase().endsWith('.webp')) {
        contentType = 'image/webp';
      }

      print('Sending file to backend: $filename');
      print('Content-Type: $contentType');
      print('File size: ${bytes.length} bytes');
      print('Request URL: $backendUrl');
      print('Timestamp: ${DateTime.now()}');

      // Add the image file with explicit content type
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename,
          contentType: MediaType.parse(contentType),
        ),
      );

      // Send request with timeout using the fresh client
      final streamedResponse = await client
          .send(request)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Backend API request timed out');
            },
          );

      final response = await http.Response.fromStream(streamedResponse);

      print('Backend response status: ${response.statusCode}');
      print('Backend response body: ${response.body}');
      print('Response timestamp: ${DateTime.now()}');

      if (response.statusCode == 200) {
        print('Raw response body type: ${response.body.runtimeType}');
        print('Raw response body length: ${response.body.length}');

        // Ensure we have a valid response body
        if (response.body.isEmpty) {
          throw Exception('Backend returned empty response body');
        }

        dynamic data;
        try {
          data = json.decode(response.body);
          print('JSON decode successful');
        } catch (e) {
          print('JSON decode failed: $e');
          throw Exception('Failed to parse backend response: $e');
        }

        print('Parsed backend data type: ${data.runtimeType}');
        print('Parsed backend data: $data');

        // Safely extract fields with null checks
        final disease = data['disease'];
        final cure = data['cure'];
        final confidence = data['confidence'];
        final rawResponse =
            data['raw_response']; // Backend includes this on parse errors

        print('Extracted - Disease: $disease');
        print('Extracted - Cure: $cure');
        print('Extracted - Confidence: $confidence');
        print('Extracted - Raw Response: $rawResponse');

        // Check if this is an error response from backend
        if (rawResponse != null) {
          print('Backend returned error response with raw_response field');
          throw Exception(
            'Backend failed to parse Gemini response. Disease: $disease, Cure: $cure',
          );
        }

        // Validate required fields
        if (disease == null || cure == null) {
          throw Exception(
            'Backend response missing required fields. Disease: $disease, Cure: $cure, Confidence: $confidence',
          );
        }

        // If confidence is missing, it might be an error response
        if (confidence == null) {
          print('Confidence is null, treating as backend error');
          throw Exception(
            'Backend response missing confidence field. This might be an error response.',
          );
        }

        // Map backend response to expected format
        final result = {
          'label': disease.toString(),
          'confidence': _parseConfidence(confidence.toString()),
          'raw_confidence': _confidenceToDouble(confidence.toString()),
          'disease_name': disease.toString(),
          'treatment': cure.toString(),
          'dosage': 'Consult agricultural expert for proper dosage',
          'prevention': 'Follow recommended agricultural practices',
          'is_healthy': disease.toString().toLowerCase().contains('no disease'),
          'all_predictions': {},
        };

        print('Successfully mapped result: $result');
        print('Result keys: ${result.keys.toList()}');
        print(
          'Result values check - disease_name: ${result['disease_name']}, treatment: ${result['treatment']}',
        );
        return result;
      } else {
        // Try to parse error message from backend
        String errorMessage = 'Unknown error';
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['detail'] ?? response.body;
        } catch (_) {
          errorMessage = response.body;
        }

        print('Backend error response: $errorMessage');

        // For 500 errors, provide more context
        if (response.statusCode == 500) {
          throw Exception(
            'Backend server error: $errorMessage. This might be due to API key issues or Gemini API problems.',
          );
        } else {
          throw Exception(
            'Backend error (${response.statusCode}): $errorMessage',
          );
        }
      }
    } catch (e) {
      print('Exception in _detectDiseaseFromBackend: $e');
      throw Exception('Backend API error: $e');
    } finally {
      // Always close the client to free resources
      client?.close();
    }
  }

  // Helper to parse confidence from backend (low/medium/high to percentage)
  static String _parseConfidence(String? confidence) {
    switch (confidence?.toLowerCase()) {
      case 'high':
        return '85.0';
      case 'medium':
        return '65.0';
      case 'low':
        return '45.0';
      default:
        return '50.0';
    }
  }

  // Helper to convert confidence string to double
  static double _confidenceToDouble(String? confidence) {
    switch (confidence?.toLowerCase()) {
      case 'high':
        return 0.85;
      case 'medium':
        return 0.65;
      case 'low':
        return 0.45;
      default:
        return 0.50;
    }
  }

  // Detect disease using local TFLite model
  static Future<Map<String, dynamic>> _detectDiseaseFromModel(
    File imageFile,
  ) async {
    if (_interpreter == null || _labels == null || _diseaseInfo == null) {
      await initialize();
    }

    try {
      // Preprocess image
      final input = _preprocessImage(imageFile);

      // Python: interpreter.set_tensor(input_details[0]['index'], img)
      // Prepare input tensor with correct shape [1, 224, 224, 3]
      final inputTensor = input.reshape([1, 224, 224, 3]);

      // Prepare output tensor
      final outputTensor = List.filled(
        _labels!.length,
        0.0,
      ).reshape([1, _labels!.length]);

      print('Running inference...');
      print('Input tensor shape: ${inputTensor.shape}');
      print('Output tensor shape: ${outputTensor.shape}');

      // Python: interpreter.invoke()
      _interpreter!.run(inputTensor, outputTensor);

      // Python: output_data = interpreter.get_tensor(output_details[0]['index'])
      final predictions = outputTensor[0] as List<double>;
      print('Raw output: $predictions');

      // Python: pred_index = np.argmax(output_data)
      // Python: confidence = np.max(output_data)
      double maxConfidence = predictions[0];
      int maxIndex = 0;

      for (int i = 1; i < predictions.length; i++) {
        if (predictions[i] > maxConfidence) {
          maxConfidence = predictions[i];
          maxIndex = i;
        }
      }

      print('Predicted class index: $maxIndex');
      print('Max confidence: $maxConfidence');
      print('All predictions with labels:');
      for (int i = 0; i < predictions.length && i < _labels!.length; i++) {
        print('  ${_labels![i]}: ${predictions[i]}');
      }

      // Python: predicted_label = labels[pred_index]
      final predictedLabel = _labels![maxIndex];
      final confidence = maxConfidence.toStringAsFixed(4);

      print('Final prediction: $predictedLabel');
      print('Confidence: $confidence');

      // Python: Get disease information from JSON
      final diseaseData =
          _diseaseInfo![predictedLabel] ??
          {
            'disease_name': 'Unknown Disease',
            'treatment':
                'Consult with agricultural expert for proper diagnosis and treatment.',
            'dosage': 'Not available',
            'prevention': 'Follow general crop care practices.',
          };

      // Convert confidence to percentage for display
      final confidencePercentage = (maxConfidence * 100).toStringAsFixed(1);

      return {
        'label': predictedLabel,
        'confidence': confidencePercentage,
        'raw_confidence': maxConfidence,
        'disease_name': diseaseData['disease_name'],
        'treatment': diseaseData['treatment'],
        'dosage': diseaseData['dosage'],
        'prevention': diseaseData['prevention'],
        'is_healthy': predictedLabel.toLowerCase().contains('healthy'),
        'all_predictions': Map.fromIterables(
          _labels!,
          predictions.map((p) => p.toStringAsFixed(4)).toList(),
        ),
      };
    } catch (e) {
      print('Error during inference: $e');
      throw Exception('Failed to analyze image: $e');
    }
  }

  // Dispose resources
  static void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _labels = null;
    _diseaseInfo = null;
  }
}

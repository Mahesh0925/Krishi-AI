import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class CropDetectionService {
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

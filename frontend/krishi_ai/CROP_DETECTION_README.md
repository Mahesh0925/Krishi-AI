# Crop Disease Detection Integration

This document explains how the TensorFlow Lite model has been integrated into the Krishi AI Flutter app for crop disease detection.

## Features

- **Real-time Disease Detection**: Uses a trained TensorFlow Lite model to identify crop diseases
- **Multi-crop Support**: Detects diseases in tomatoes, potatoes, and bell peppers
- **Comprehensive Information**: Provides disease name, treatment, dosage, and prevention tips
- **Healthy Crop Recognition**: Identifies healthy crops and provides maintenance tips

## Model Details

- **Model File**: `assets/model.tflite`
- **Labels**: `assets/labels.txt` (15 different classes)
- **Disease Information**: `assets/disease_info.json`
- **Input Size**: 224x224x3 (RGB images)
- **Supported Crops**: Tomato, Potato, Bell Pepper

## Supported Diseases

### Tomato
- Bacterial Spot
- Early Blight
- Late Blight
- Leaf Mold
- Septoria Leaf Spot
- Spider Mites (Two-spotted)
- Target Spot
- Yellow Leaf Curl Virus
- Mosaic Virus
- Healthy

### Potato
- Early Blight
- Late Blight
- Healthy

### Bell Pepper
- Bacterial Spot
- Healthy

## How It Works

1. **Image Capture**: User takes a photo or selects from gallery
2. **Preprocessing**: Image is resized to 224x224 and normalized
3. **Model Inference**: TensorFlow Lite model processes the image
4. **Result Processing**: Highest confidence prediction is selected
5. **Information Retrieval**: Disease details are fetched from JSON database
6. **Display**: Results shown with treatment recommendations

## Usage

1. Open the app and navigate to the camera screen
2. Take a photo of the affected crop leaf or select from gallery
3. Wait for AI analysis (2-3 seconds)
4. View detailed results including:
   - Disease identification
   - Confidence percentage
   - Treatment recommendations
   - Dosage information
   - Prevention tips
   - Symptoms description

## Technical Implementation

### Files Modified/Created

- `lib/services/crop_detection_service.dart` - Main service for model integration
- `lib/View/camera_screen.dart` - Updated to use real AI analysis
- `lib/View/detection_screen.dart` - Enhanced UI for comprehensive results
- `pubspec.yaml` - Added image processing dependency and asset declarations

### Dependencies Added

- `image: ^4.0.17` - For image preprocessing
- `tflite_flutter: ^0.12.1` - For TensorFlow Lite model execution

### Key Classes

- `CropDetectionService` - Handles model loading, image preprocessing, and inference
- `CameraScreen` - Manages image capture and analysis workflow
- `ResultScreen` - Displays comprehensive analysis results

## Error Handling

- Model initialization failures are gracefully handled
- Image processing errors show user-friendly messages
- Fallback responses provided when analysis fails
- Permission handling for camera access

## Performance Considerations

- Model is loaded once at app startup
- Images are resized to optimal input size
- Inference typically takes 1-3 seconds on modern devices
- Memory usage is optimized through proper resource disposal

## Future Enhancements

- Support for additional crop types
- Batch processing for multiple images
- Offline model updates
- Integration with weather data for better recommendations
- Historical analysis tracking
# Model Troubleshooting Guide

If your model is not giving correct predictions, follow this step-by-step troubleshooting guide.

## 🔍 Step 1: Check Model Output with Debug Screen

1. Take a photo of a crop you know the disease of
2. After analysis, tap the **bug icon** (🐛) in the top-right corner
3. Review the debug screen to see:
   - All prediction scores for each class
   - Model input/output information
   - Top prediction vs expected result

## 🛠️ Step 2: Common Issues and Solutions

### Issue 1: All predictions have similar low scores (e.g., all around 6-7%)
**Problem**: Incorrect normalization
**Solution**: In `crop_detection_service.dart`, try different normalization:

```dart
// Current: [0, 1] normalization
input[pixelIndex++] = pixel.r / 255.0;

// Try: [-1, 1] normalization (uncomment these lines)
input[pixelIndex++] = (pixel.r / 255.0) * 2.0 - 1.0;
input[pixelIndex++] = (pixel.g / 255.0) * 2.0 - 1.0;
input[pixelIndex++] = (pixel.b / 255.0) * 2.0 - 1.0;

// Or try: ImageNet normalization (uncomment these lines)
input[pixelIndex++] = (pixel.r / 255.0 - 0.485) / 0.229;
input[pixelIndex++] = (pixel.g / 255.0 - 0.456) / 0.224;
input[pixelIndex++] = (pixel.b / 255.0 - 0.406) / 0.225;
```

### Issue 2: Model always predicts the same class
**Problem**: Model output needs softmax activation
**Solution**: In `crop_detection_service.dart`, uncomment this line:

```dart
// Apply softmax if needed (uncomment if your model doesn't include softmax)
final softmaxPredictions = _applySoftmax(predictions);
// Then use softmaxPredictions instead of predictions for finding max
```

### Issue 3: Wrong input size
**Problem**: Model expects different input dimensions
**Solution**: Check console logs for "Model Input Shape" and adjust:

```dart
// If your model expects 256x256 instead of 224x224
image = img.copyResize(image, width: 256, height: 256);
final input = Float32List(256 * 256 * 3);
// Update loops accordingly
```

### Issue 4: Incorrect label mapping
**Problem**: Labels don't match model output order
**Solution**: Verify `assets/labels.txt` matches your training labels exactly:
- Same order as training
- Same spelling and format
- No extra spaces or empty lines

## 🔧 Step 3: Model-Specific Adjustments

### For TensorFlow/Keras Models:
- Usually need [0, 1] normalization
- May need softmax if not included in model
- Check if model expects RGB or BGR

### For PyTorch Models:
- Often need [-1, 1] or ImageNet normalization
- Usually include softmax in model
- Typically expect RGB format

### For Custom Models:
- Check your training preprocessing exactly
- Match normalization, input size, and color format
- Verify label order matches training

## 📊 Step 4: Validation Steps

1. **Test with known samples**: Use images you're certain of the disease
2. **Check confidence scores**: Healthy predictions should be >80% for good images
3. **Verify preprocessing**: Console logs show pixel values and tensor shapes
4. **Compare with training**: Ensure same preprocessing as training pipeline

## 🐛 Step 5: Enable Detailed Debugging

Add more logging to see exactly what's happening:

```dart
// In _preprocessImage method, add:
print('First few pixel values: ${input.take(12).toList()}');
print('Min pixel value: ${input.reduce(math.min)}');
print('Max pixel value: ${input.reduce(math.max)}');

// In detectDisease method, add:
print('Raw predictions sum: ${predictions.reduce((a, b) => a + b)}');
print('Top 3 predictions:');
final sortedIndices = List.generate(predictions.length, (i) => i)
  ..sort((a, b) => predictions[b].compareTo(predictions[a]));
for (int i = 0; i < 3 && i < sortedIndices.length; i++) {
  final idx = sortedIndices[i];
  print('  ${_labels![idx]}: ${(predictions[idx] * 100).toStringAsFixed(2)}%');
}
```

## 🎯 Step 6: Quick Fixes to Try

1. **Change normalization**: Try the three options mentioned above
2. **Enable softmax**: Uncomment the softmax line
3. **Adjust input size**: Match your training input size
4. **Check RGB vs BGR**: Some models expect BGR format
5. **Verify labels**: Ensure labels.txt matches training exactly

## 📱 Testing Your Changes

1. Make changes to `crop_detection_service.dart`
2. Hot reload the app
3. Test with the same image
4. Check debug screen for improvements
5. Look at console logs for detailed information

## 🆘 If Still Not Working

1. **Share console logs**: The debug output will show what's happening
2. **Check model format**: Ensure .tflite model is compatible
3. **Verify assets**: Make sure all files are in assets folder and declared in pubspec.yaml
4. **Test model separately**: Try the model in Python first to verify it works

## 📋 Checklist

- [ ] Model loads without errors
- [ ] Input tensor shape matches model expectations
- [ ] Normalization matches training preprocessing
- [ ] Labels.txt order matches model output
- [ ] Softmax applied if needed
- [ ] Debug screen shows reasonable prediction scores
- [ ] Console logs show expected values

Remember: The debug screen and console logs are your best friends for troubleshooting!
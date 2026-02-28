# Tutorial Testing Guide - How to See the Tutorial

## Problem: Tutorial Not Showing?

The tutorial only shows **once** when you first open the app. If you've already opened the app before, `tutorialSeen` is set to `true` in SharedPreferences, so the tutorial won't show again.

## Solution: Reset the Tutorial

### Method 1: Add Temporary Reset Button (Recommended for Testing)

Add this button temporarily to your Profile Settings screen or anywhere convenient:

```dart
// Add this import at the top
import 'package:krishi_ai/utils/tutorial_helper.dart';

// Add this button anywhere in your UI (temporarily for testing)
ElevatedButton(
  onPressed: () async {
    await TutorialHelper.resetTutorial();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tutorial reset! Please restart the app.'),
        backgroundColor: Colors.green,
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
  ),
  child: const Text('Reset Tutorial (Testing)'),
)
```

**Steps:**
1. Add the button to any screen
2. Tap the button
3. Close and restart the app
4. Tutorial will appear!

### Method 2: Clear App Data (Android)

1. Go to Settings → Apps → Krishi AI
2. Tap "Storage"
3. Tap "Clear Data" or "Clear Storage"
4. Open app again
5. Tutorial will appear!

### Method 3: Delete and Reinstall (iOS)

1. Delete the Krishi AI app
2. Reinstall from Xcode or TestFlight
3. Open app
4. Tutorial will appear!

### Method 4: Use Flutter DevTools

```bash
# Run this in terminal while app is running
flutter run

# Then in another terminal:
flutter pub run shared_preferences:clear
```

### Method 5: Code-Based Reset (Temporary)

Temporarily comment out the check in `home_screen.dart`:

```dart
Future<void> _checkAndShowTutorial() async {
  final prefs = await SharedPreferences.getInstance();
  final tutorialSeen = prefs.getBool('tutorialSeen') ?? false;

  // Temporarily comment this out to always show tutorial:
  // if (!tutorialSeen) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          _showTutorial();
        }
      });
    });
  // }
}
```

## Verify Tutorial is Working

### Check Console Logs

When the app starts, you should see these logs:

```
🎓 Tutorial check: tutorialSeen = false
🎓 Tutorial will be shown after delay
🎓 Showing tutorial now
🎓 Creating tutorial...
🎓 Tutorial created, showing now...
🎓 Tutorial show() called
```

If you see:
```
🎓 Tutorial check: tutorialSeen = true
🎓 Tutorial already seen, skipping
```

This means the tutorial has already been shown. Use one of the reset methods above.

## Quick Test Script

Add this to your Profile Settings screen temporarily:

```dart
import 'package:krishi_ai/utils/tutorial_helper.dart';

// Add this widget in your settings
Card(
  color: Colors.orange.shade100,
  child: ListTile(
    leading: Icon(Icons.bug_report, color: Colors.orange),
    title: Text('Tutorial Testing'),
    subtitle: Text('For development only'),
    trailing: ElevatedButton(
      onPressed: () async {
        await TutorialHelper.resetTutorial();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Tutorial Reset'),
            content: Text('Please close and restart the app to see the tutorial.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
      child: Text('Reset'),
    ),
  ),
)
```

## Expected Behavior

### First Time User:
1. Opens app
2. Navigates to Home Screen
3. After 1 second delay
4. Dark overlay appears (80% opacity)
5. First button (Scan Disease) is highlighted
6. Description box appears below
7. Shows "Skip" and "Next" buttons

### After Tutorial Completion:
1. Opens app
2. Navigates to Home Screen
3. No tutorial appears
4. Normal app experience

## Troubleshooting

### Tutorial Still Not Showing?

1. **Check Console Logs**
   - Look for 🎓 emoji logs
   - See what `tutorialSeen` value is

2. **Verify GlobalKeys**
   - Make sure buttons have keys assigned
   - Check: `key: scanDiseaseKey`

3. **Check Package Installation**
   ```bash
   flutter pub get
   flutter clean
   flutter pub get
   flutter run
   ```

4. **Verify Imports**
   ```dart
   import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
   import 'package:shared_preferences/shared_preferences.dart';
   ```

5. **Check for Errors**
   - Look for red errors in console
   - Check if any exceptions are thrown

### Common Issues

#### Issue: "tutorialSeen = true"
**Solution**: Reset using Method 1 or 2 above

#### Issue: No console logs at all
**Solution**: Check if `_checkAndShowTutorial()` is called in `initState()`

#### Issue: Logs show but tutorial doesn't appear
**Solution**: 
- Check if GlobalKeys are assigned to buttons
- Verify buttons are rendered before tutorial shows
- Increase delay to 2000ms

#### Issue: Tutorial appears but buttons not highlighted
**Solution**:
- Verify GlobalKeys match between declaration and assignment
- Check if widgets are built before tutorial shows

## Production Checklist

Before releasing to production:

1. ✅ Remove all debug buttons
2. ✅ Remove console.log statements (or keep minimal)
3. ✅ Test on fresh install
4. ✅ Verify tutorial shows only once
5. ✅ Test in all languages (English, Hindi, Marathi)
6. ✅ Verify "Skip" works
7. ✅ Verify "Next" works
8. ✅ Verify "Got it!" completes tutorial

## Quick Commands

```bash
# Reset and test
flutter clean
flutter pub get
flutter run

# Clear app data (while running)
# Android: Settings → Apps → Clear Data
# iOS: Delete and reinstall

# Check SharedPreferences value
# Add this temporarily in your code:
final prefs = await SharedPreferences.getInstance();
print('tutorialSeen: ${prefs.getBool('tutorialSeen')}');
```

## Need Help?

If tutorial still doesn't show:
1. Check all console logs
2. Verify `tutorialSeen` is `false`
3. Make sure GlobalKeys are assigned
4. Ensure no errors in console
5. Try increasing delay to 2000ms
6. Check if context is available when showing tutorial

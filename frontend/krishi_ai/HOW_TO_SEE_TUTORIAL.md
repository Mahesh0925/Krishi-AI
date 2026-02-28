# How to See the Tutorial on Home Screen

## Why Tutorial is Not Showing

The tutorial only shows **ONCE** when you first open the app. If you've already opened the app before, it won't show again because `tutorialSeen` is saved as `true` in SharedPreferences.

## ✅ EASIEST WAY: Use the Reset Button

I've added a **temporary reset button** in Profile Settings for testing:

### Steps:
1. Open the app
2. Go to **Profile Settings** (bottom navigation)
3. Scroll down to find **"Reset Tutorial (Testing)"** button (orange color)
4. Tap the button
5. You'll see a green message: "Tutorial reset! Please restart the app"
6. **Close the app completely** (swipe away from recent apps)
7. **Open the app again**
8. Navigate to Home Screen
9. **Tutorial will appear!** 🎉

## What You'll See

After resetting and restarting:

1. **Home Screen loads**
2. **After 1 second** → Dark overlay appears
3. **First button highlighted** → "Scan Disease" button glows
4. **Description box appears** → Shows in your selected language
5. **Buttons shown** → "Skip" and "Next" (or in Hindi/Marathi)

### Tutorial Steps:
- **Step 1**: Scan Disease button
- **Step 2**: Weather button  
- **Step 3**: Mandi Prices button
- **Step 4**: Government Schemes button

## Check Console Logs

When the app starts, look for these logs in your console:

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

This means you need to reset the tutorial using the button.

## Alternative Methods (if button doesn't work)

### Method 2: Clear App Data (Android)
1. Settings → Apps → Krishi AI
2. Storage → Clear Data
3. Open app again

### Method 3: Reinstall App (iOS)
1. Delete app
2. Reinstall
3. Open app

### Method 4: Manual Code Change
Temporarily edit `home_screen.dart`:

```dart
// Find this method and comment out the if statement:
Future<void> _checkAndShowTutorial() async {
  final prefs = await SharedPreferences.getInstance();
  final tutorialSeen = prefs.getBool('tutorialSeen') ?? false;

  // Comment these lines:
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

## Tutorial Features

### ✅ Multilanguage Support
- **English**: "Scan Crop Disease" → "Press here to capture..."
- **Hindi**: "फसल रोग स्कैन करें" → "फसल की तस्वीर लेने..."
- **Marathi**: "पीक रोग स्कॅन करा" → "पिकाचा फोटो घेण्यासाठी..."

### ✅ Interactive
- Dark overlay (80% opacity)
- Highlighted buttons
- Description boxes
- Skip/Next buttons
- Saves completion status

### ✅ One-Time Only
- Shows only on first launch
- Never appears again after completion
- Can be reset for testing

## Troubleshooting

### Problem: Reset button doesn't work
**Solution**: Make sure you **completely close and restart** the app after tapping reset

### Problem: No console logs
**Solution**: Check if app is running in debug mode with console visible

### Problem: Tutorial appears but buttons not highlighted
**Solution**: 
- Check if GlobalKeys are assigned to buttons
- Restart app after reset

### Problem: Tutorial in wrong language
**Solution**: 
- Change language in Profile Settings first
- Then reset tutorial
- Restart app

## Before Production Release

**IMPORTANT**: Remove the orange "Reset Tutorial" button from Profile Settings before releasing to users!

Find this code in `profile_setting.dart` and delete it:
```dart
// 🧪 TEMPORARY: Reset Tutorial Button (Remove before production)
_settingsTile(
  icon: Icons.refresh,
  title: "Reset Tutorial (Testing)",
  // ... rest of the code
),
```

## Summary

1. ✅ Tutorial is properly implemented
2. ✅ Works in all languages (English, Hindi, Marathi)
3. ✅ Shows only once per user
4. ✅ Can be reset using the orange button in Profile Settings
5. ✅ Must restart app after reset to see tutorial

**To see tutorial**: Tap orange "Reset Tutorial" button → Close app → Reopen app → Tutorial appears! 🎊

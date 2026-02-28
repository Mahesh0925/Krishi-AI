# Tutorial Walkthrough - Quick Reference

## For Testing: Reset Tutorial

### Method 1: Code (Temporary)
Add this button somewhere in your UI:
```dart
ElevatedButton(
  onPressed: () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tutorialSeen');
    print('Tutorial reset! Restart app to see it again.');
  },
  child: Text('Reset Tutorial'),
)
```

### Method 2: Clear App Data
- **Android**: Settings → Apps → Krishi AI → Storage → Clear Data
- **iOS**: Delete app and reinstall

### Method 3: Flutter Command
```bash
flutter run --clear-cache
```

## Key Code Locations

### GlobalKeys Declaration
**File**: `lib/View/home_screen.dart`
**Line**: ~25-28
```dart
final GlobalKey scanDiseaseKey = GlobalKey();
final GlobalKey weatherKey = GlobalKey();
final GlobalKey mandiPricesKey = GlobalKey();
final GlobalKey schemesKey = GlobalKey();
```

### Tutorial Check
**File**: `lib/View/home_screen.dart`
**Method**: `_checkAndShowTutorial()`
```dart
Future<void> _checkAndShowTutorial() async {
  final prefs = await SharedPreferences.getInstance();
  final tutorialSeen = prefs.getBool('tutorialSeen') ?? false;
  
  if (!tutorialSeen) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _showTutorial();
      });
    });
  }
}
```

### Tutorial Targets
**File**: `lib/View/home_screen.dart`
**Method**: `_createTargets()`

## Quick Customization

### Change Tutorial Delay
```dart
// Current: 500ms
Future.delayed(const Duration(milliseconds: 500), () {
  _showTutorial();
});

// Change to 1 second:
Future.delayed(const Duration(milliseconds: 1000), () {
  _showTutorial();
});
```

### Change Overlay Opacity
```dart
// Current: 0.8 (80% dark)
tutorialCoachMark = TutorialCoachMark(
  opacityShadow: 0.8,
  // ...
);

// Make darker: 0.9
// Make lighter: 0.6
```

### Change Highlight Padding
```dart
// Current: 10px
tutorialCoachMark = TutorialCoachMark(
  paddingFocus: 10,
  // ...
);

// More padding: 20
// Less padding: 5
```

### Change Description Box Position
```dart
TargetContent(
  align: ContentAlign.bottom, // Current
  // Options: top, bottom, left, right, custom
  builder: (context, controller) {
    // ...
  },
)
```

## Add New Tutorial Step

### Step 1: Add GlobalKey
```dart
final GlobalKey myNewButtonKey = GlobalKey();
```

### Step 2: Assign Key to Widget
```dart
_DashboardButton(
  key: myNewButtonKey,
  icon: Icons.my_icon,
  title: "My Title",
  // ...
)
```

### Step 3: Add Target in _createTargets()
```dart
targets.add(
  TargetFocus(
    identify: "myNewButtonKey",
    keyTarget: myNewButtonKey,
    shape: ShapeLightFocus.RRect,
    radius: 16,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2923),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF59F20D), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("My Title", style: /* ... */),
                Text("My description", style: /* ... */),
                // Add Next/Skip buttons
              ],
            ),
          );
        },
      ),
    ],
  ),
);
```

## Common Issues & Fixes

### Issue: Tutorial Not Showing
**Fix**: Clear SharedPreferences
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.remove('tutorialSeen');
```

### Issue: Button Not Highlighting
**Fix**: Ensure GlobalKey is assigned
```dart
// Wrong:
_DashboardButton(icon: Icons.home, ...)

// Correct:
_DashboardButton(key: myKey, icon: Icons.home, ...)
```

### Issue: Description Box Cut Off
**Fix**: Change alignment
```dart
// If bottom is cut off, use top:
align: ContentAlign.top,

// If right is cut off, use left:
align: ContentAlign.left,
```

### Issue: Tutorial Shows Every Time
**Fix**: Check onFinish callback
```dart
onFinish: () async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('tutorialSeen', true); // Must save!
},
```

## Tutorial Flow Diagram

```
App Launch
    ↓
Home Screen initState()
    ↓
_checkAndShowTutorial()
    ↓
Check SharedPreferences
    ↓
tutorialSeen == false?
    ↓ YES                    ↓ NO
Show Tutorial          Skip Tutorial
    ↓
Step 1: Scan Disease
    ↓ (Next)
Step 2: Weather
    ↓ (Next)
Step 3: Mandi Prices
    ↓ (Next)
Step 4: Schemes
    ↓ (Got it!)
Save tutorialSeen = true
    ↓
Tutorial Complete
```

## Package Info

**Name**: tutorial_coach_mark
**Version**: ^1.2.11
**Pub.dev**: https://pub.dev/packages/tutorial_coach_mark
**GitHub**: https://github.com/RafaelBarbosatec/tutorial_coach_mark

## Dependencies Already in Project

- ✅ shared_preferences: ^2.5.4 (already installed)
- ✅ google_fonts: ^8.0.2 (already installed)
- ✅ flutter/material.dart (built-in)

## Color Scheme Used

```dart
const primary = Color(0xFF59F20D);      // Green
const backgroundDark = Color(0xFF162210); // Dark green
const surfaceDark = Color(0xFF1E2923);   // Card background
```

## Text Styles

```dart
// Title
GoogleFonts.inter(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Color(0xFF59F20D),
)

// Description
GoogleFonts.inter(
  fontSize: 16,
  color: Colors.white,
)

// Button
GoogleFonts.inter(
  fontWeight: FontWeight.bold,
  fontSize: 16,
)
```

## Performance Tips

1. Tutorial only runs once (first launch)
2. Minimal memory footprint
3. No background processes
4. SharedPreferences is fast
5. No network calls
6. No heavy computations

## Debugging

### Enable Debug Prints
```dart
Future<void> _checkAndShowTutorial() async {
  final prefs = await SharedPreferences.getInstance();
  final tutorialSeen = prefs.getBool('tutorialSeen') ?? false;
  
  print('🎓 Tutorial seen: $tutorialSeen'); // Add this
  
  if (!tutorialSeen) {
    print('🎓 Showing tutorial...'); // Add this
    // ...
  }
}
```

### Check SharedPreferences Value
```dart
final prefs = await SharedPreferences.getInstance();
print('tutorialSeen: ${prefs.getBool('tutorialSeen')}');
```

### Force Show Tutorial (Testing)
```dart
// Temporarily comment out the check:
// if (!tutorialSeen) {
  _showTutorial();
// }
```

## Production Checklist

Before releasing:
- [ ] Test tutorial on fresh install
- [ ] Verify tutorial doesn't show twice
- [ ] Check all button highlights work
- [ ] Test "Skip" functionality
- [ ] Test "Next" navigation
- [ ] Verify SharedPreferences saves
- [ ] Test on different screen sizes
- [ ] Check text readability
- [ ] Ensure no console errors
- [ ] Test on both Android and iOS

## Quick Commands

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Clear cache and run
flutter clean && flutter pub get && flutter run

# Build release
flutter build apk --release
flutter build ios --release
```

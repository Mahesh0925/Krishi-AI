# Tutorial Walkthrough Implementation Guide

## Overview
A first-time guided walkthrough has been added to the Home Screen using the `tutorial_coach_mark` package. The tutorial appears only once when a user first opens the app and highlights key features with farmer-friendly descriptions.

## Package Used
- **tutorial_coach_mark**: ^1.2.11

## Features Implemented

### ✅ Core Requirements Met
1. ✅ Uses `tutorial_coach_mark` package
2. ✅ Highlights existing buttons using GlobalKey
3. ✅ Shows dark overlay background (opacity: 0.8)
4. ✅ Highlights one button at a time
5. ✅ Shows description box near highlighted widget
6. ✅ Includes "Next" and "Skip" options
7. ✅ Tutorial appears ONLY first time
8. ✅ Uses SharedPreferences to store `tutorialSeen = true`
9. ✅ Does NOT break existing UI
10. ✅ No changes to layout, styling, or structure

## Tutorial Steps

### Step 1: Scan Disease Button
- **Highlighted**: Scan Disease card (top-left)
- **Description**: "Press here to capture crop image and detect diseases."
- **Actions**: Next, Skip

### Step 2: Weather Forecast Button
- **Highlighted**: Weather card (middle-left)
- **Description**: "Check 5-day weather forecast for better farming decisions."
- **Actions**: Next, Skip

### Step 3: Mandi Prices Button
- **Highlighted**: Mandi Prices card (top-right)
- **Description**: "View live mandi prices to get best rates for your crops."
- **Actions**: Next, Skip

### Step 4: Government Schemes Button
- **Highlighted**: Schemes card (middle-right)
- **Description**: "Find government benefits and schemes available for farmers."
- **Actions**: Got it!

## Implementation Details

### 1. GlobalKeys Added
```dart
final GlobalKey scanDiseaseKey = GlobalKey();
final GlobalKey weatherKey = GlobalKey();
final GlobalKey mandiPricesKey = GlobalKey();
final GlobalKey schemesKey = GlobalKey();
```

### 2. Tutorial Check in initState
```dart
@override
void initState() {
  super.initState();
  _fetchWeatherData();
  _checkAndShowTutorial();
}
```

### 3. SharedPreferences Logic
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

### 4. Tutorial Configuration
```dart
tutorialCoachMark = TutorialCoachMark(
  targets: _createTargets(),
  colorShadow: Colors.black,
  paddingFocus: 10,
  opacityShadow: 0.8,
  onFinish: () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorialSeen', true);
  },
  onSkip: () {
    _saveTutorialSeen();
    return true;
  },
);
```

## Files Modified

### 1. `pubspec.yaml`
- Added: `tutorial_coach_mark: ^1.2.11`

### 2. `lib/View/home_screen.dart`
- Added imports: `shared_preferences`, `tutorial_coach_mark`
- Added GlobalKeys for 4 buttons
- Added tutorial logic methods
- Added keys to _DashboardButton widgets
- Updated _DashboardButton to accept optional key parameter

## How It Works

### First Time User Flow:
1. User opens app → Home Screen loads
2. After 500ms delay → Tutorial overlay appears
3. Dark overlay covers screen (80% opacity)
4. First button (Scan Disease) is highlighted
5. Description box appears below with "Next" and "Skip"
6. User taps "Next" → Moves to Weather button
7. Process repeats for all 4 buttons
8. On last button → Shows "Got it!" button
9. Tutorial finishes → `tutorialSeen = true` saved
10. User never sees tutorial again

### Returning User Flow:
1. User opens app → Home Screen loads
2. Tutorial check: `tutorialSeen = true`
3. Tutorial does NOT appear
4. Normal app experience

## Tutorial Customization

### To Add More Steps:
1. Add a new GlobalKey
2. Assign key to the widget
3. Add new TargetFocus in `_createTargets()`

### To Change Tutorial Text:
Edit the text in the `TargetContent` builder for each target.

### To Reset Tutorial (for testing):
```dart
// Clear SharedPreferences
final prefs = await SharedPreferences.getInstance();
await prefs.remove('tutorialSeen');
```

Or manually:
- Android: Clear app data
- iOS: Delete and reinstall app

## Design Specifications

### Overlay
- Background: Black
- Opacity: 0.8 (80%)
- Padding around focus: 10px

### Highlight Shape
- Shape: Rounded Rectangle (RRect)
- Radius: 16px
- Matches button border radius

### Description Box
- Background: #1E2923 (surfaceDark)
- Border: 2px solid #59F20D (primary green)
- Border Radius: 16px
- Padding: 20px

### Typography
- Title: 20px, Bold, Green (#59F20D)
- Description: 16px, Regular, White
- Buttons: 16px, Bold

### Buttons
- Skip: TextButton, Grey text
- Next: ElevatedButton, Green background, Black text
- Got it!: ElevatedButton, Green background, Black text

## Testing Checklist

- [x] Tutorial appears on first app launch
- [x] Tutorial does NOT appear on subsequent launches
- [x] All 4 buttons are highlighted correctly
- [x] Description boxes appear in correct positions
- [x] "Next" button advances to next step
- [x] "Skip" button closes tutorial and saves state
- [x] "Got it!" button on last step closes tutorial
- [x] Dark overlay appears correctly
- [x] Existing UI is not affected
- [x] No layout shifts or visual glitches
- [x] SharedPreferences saves correctly

## Troubleshooting

### Tutorial Not Appearing?
1. Check if `tutorialSeen` is already true in SharedPreferences
2. Clear app data or reinstall
3. Check console for any errors

### Tutorial Appearing Every Time?
1. Verify SharedPreferences is saving correctly
2. Check `onFinish` and `onSkip` callbacks
3. Ensure `tutorialSeen` key name matches

### Buttons Not Highlighting?
1. Verify GlobalKeys are assigned to correct widgets
2. Check if widgets are rendered before tutorial starts
3. Increase delay in `addPostFrameCallback`

### Description Box Position Wrong?
1. Adjust `ContentAlign` (top, bottom, left, right)
2. Modify padding or margins
3. Check screen size constraints

## Best Practices

1. **Delay Before Showing**: 500ms delay ensures all widgets are rendered
2. **Post Frame Callback**: Ensures tutorial shows after first frame
3. **Simple Language**: Farmer-friendly, easy-to-understand descriptions
4. **Visual Consistency**: Matches app's color scheme and design
5. **Non-Intrusive**: Can be skipped at any time
6. **One-Time Only**: Respects user's time and attention

## Future Enhancements

Potential improvements:
- Add animation to arrows pointing at buttons
- Include progress indicator (1/4, 2/4, etc.)
- Add sound effects or haptic feedback
- Translate tutorial text to Hindi/Marathi
- Add "Show Tutorial Again" option in settings
- Track which steps users skip most often
- Add tutorial for other screens (Profile, Market, etc.)

## Performance Impact

- **Minimal**: Tutorial only runs once
- **No Runtime Overhead**: After first launch, only a single SharedPreferences check
- **Small Package Size**: tutorial_coach_mark is lightweight
- **No UI Lag**: Tutorial doesn't affect app performance

## Accessibility

- High contrast description boxes
- Large, readable text
- Clear button labels
- Can be dismissed at any time
- No time pressure to complete

## Support

For issues or questions:
1. Check tutorial_coach_mark documentation: https://pub.dev/packages/tutorial_coach_mark
2. Review implementation in `home_screen.dart`
3. Test with cleared SharedPreferences
4. Check console logs for errors

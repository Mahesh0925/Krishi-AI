# Multilanguage Support Guide

## Overview
The Krishi AI app now supports multiple languages: English, Hindi (हिन्दी), and Marathi (मराठी).

## Implementation Details

### Architecture
- **GetX Package**: Used for state management and internationalization
- **Translations File**: `lib/translations/app_translations.dart` contains all translations
- **Language Controller**: `lib/controllers/language_controller.dart` manages language state
- **Persistence**: Selected language is saved using SharedPreferences

### Supported Languages
1. **English** (en_US) - Default
2. **Hindi** (hi_IN) - हिन्दी
3. **Marathi** (mr_IN) - मराठी

## How to Use

### For Users
1. Open the app
2. Navigate to Profile Settings
3. Tap on "Language" option
4. Select your preferred language
5. Tap "CHANGE LANGUAGE" button
6. The app will immediately update to the selected language

### For Developers

#### Adding New Translations
1. Open `lib/translations/app_translations.dart`
2. Add your translation key to all three language maps:

```dart
'en_US': {
  'your_key': 'Your English Text',
  // ... other translations
},
'hi_IN': {
  'your_key': 'आपका हिंदी पाठ',
  // ... other translations
},
'mr_IN': {
  'your_key': 'तुमचा मराठी मजकूर',
  // ... other translations
},
```

#### Using Translations in Code
Replace hardcoded strings with translation keys:

```dart
// Before
Text("Welcome")

// After
Text("welcome".tr)
```

#### Adding a New Language
1. Add the language to `app_translations.dart`:
```dart
'es_ES': {
  'welcome': 'Bienvenido',
  // ... all other keys
}
```

2. Update `language_controller.dart` to handle the new language:
```dart
case 'es':
  newLocale = const Locale('es', 'ES');
  break;
```

3. Add the language option to `change_language.dart`:
```dart
{'icon': 'E', 'title': 'Español', 'subtitle': 'spanish', 'code': 'es'},
```

## Translated Screens
The following screens have been fully translated:
- ✅ Home Screen (Dashboard)
- ✅ Profile Settings
- ✅ Language Selection
- ✅ Login Screen
- ✅ Signup Screen
- ✅ Camera/Scan Screen
- ✅ Edit Profile Screen

## Translation Keys Reference

### Common Keys
- `app_name`, `welcome`, `continue`, `cancel`, `save`, `edit`, `delete`
- `confirm`, `yes`, `no`, `ok`, `loading`, `error`, `success`, `retry`

### Greetings
- `good_morning`, `good_afternoon`, `good_evening`, `good_night`

### Home Screen
- `quick_actions`, `scan_disease`, `advisory`, `weather`, `mandi_prices`
- `schemes`, `history`, `humidity`, `wind`, `rain`

### Authentication
- `login`, `sign_up`, `email`, `password`, `forgot_password`
- `create_account`, `login_successful`, `signup_successful`

### Profile
- `profile_settings`, `edit_profile`, `notifications`, `language`
- `privacy_security`, `help_support`, `logout`

## Best Practices

1. **Always use translation keys**: Never hardcode user-facing text
2. **Keep keys descriptive**: Use clear, meaningful key names
3. **Maintain consistency**: Use the same key for the same text across screens
4. **Test all languages**: Verify translations display correctly in all supported languages
5. **Handle text overflow**: Some languages (like Hindi/Marathi) may require more space

## Technical Notes

- Language preference is persisted across app restarts
- Language changes take effect immediately without app restart
- The app falls back to English if a translation key is missing
- GetX's `.tr` extension automatically fetches the correct translation

## Future Enhancements

Potential improvements:
- Add more regional languages (Tamil, Telugu, Bengali, etc.)
- Implement RTL support for languages like Urdu
- Add voice-based language selection
- Translate dynamic content from APIs
- Add language-specific date/time formatting

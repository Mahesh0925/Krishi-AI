import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String _languageKey = 'selected_language';

  final Rx<Locale> _locale = const Locale('en', 'US').obs;

  Locale get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);

    if (languageCode != null) {
      switch (languageCode) {
        case 'en':
          _locale.value = const Locale('en', 'US');
          break;
        case 'hi':
          _locale.value = const Locale('hi', 'IN');
          break;
        case 'mr':
          _locale.value = const Locale('mr', 'IN');
          break;
        default:
          _locale.value = const Locale('en', 'US');
      }
      Get.updateLocale(_locale.value);
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    Locale newLocale;

    switch (languageCode) {
      case 'en':
        newLocale = const Locale('en', 'US');
        break;
      case 'hi':
        newLocale = const Locale('hi', 'IN');
        break;
      case 'mr':
        newLocale = const Locale('mr', 'IN');
        break;
      default:
        newLocale = const Locale('en', 'US');
    }

    _locale.value = newLocale;
    Get.updateLocale(newLocale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  String getCurrentLanguageCode() {
    switch (_locale.value.languageCode) {
      case 'hi':
        return 'hi';
      case 'mr':
        return 'mr';
      default:
        return 'en';
    }
  }
}

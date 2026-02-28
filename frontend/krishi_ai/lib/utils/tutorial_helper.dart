import 'package:shared_preferences/shared_preferences.dart';

class TutorialHelper {
  // Reset tutorial so it shows again
  static Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tutorialSeen');
    print('🎓 Tutorial reset! Restart app to see it again.');
  }

  // Check if tutorial has been seen
  static Future<bool> hasTutorialBeenSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('tutorialSeen') ?? false;
  }

  // Mark tutorial as seen
  static Future<void> markTutorialAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorialSeen', true);
  }
}

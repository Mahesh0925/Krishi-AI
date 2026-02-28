import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // Common
      'app_name': 'Krishi AI',
      'welcome': 'Welcome',
      'continue': 'Continue',
      'cancel': 'Cancel',
      'save': 'Save',
      'edit': 'Edit',
      'delete': 'Delete',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'retry': 'Retry',

      // Greetings
      'good_morning': 'Good Morning,',
      'good_afternoon': 'Good Afternoon,',
      'good_evening': 'Good Evening,',
      'good_night': 'Good Night,',

      // Home Screen
      'quick_actions': 'Quick Actions',
      'edit_grid': 'Edit Grid',
      'scan_disease': 'Scan Disease',
      'detect_crop_issues': 'Detect crop issues',
      'advisory': 'Advisory',
      'ask_krishi_bot': 'Ask Krishi Bot',
      'weather': 'Weather',
      'five_day_forecast': '5-day forecast',
      'mandi_prices': 'Mandi Prices',
      'live_market_rates': 'Live market rates',
      'schemes': 'Schemes',
      'govt_benefits': 'Govt. benefits',
      'history': 'History',
      'past_scans_data': 'Past scans & data',
      'press_back_again': 'Press back again to exit',

      // Weather
      'humidity': 'HUMIDITY',
      'wind': 'WIND',
      'rain': 'RAIN',
      'aqi_good': 'AQI 45 (Good)',

      // Profile Settings
      'profile_settings': 'Profile Settings',
      'edit_profile': 'Edit Profile',
      'change_name_photo': 'Change your name, photo, or phone number',
      'notifications': 'Notifications',
      'manage_alert_preferences': 'Manage your alert preferences',
      'language': 'Language',
      'select_preferred_language': 'Select preferred app language',
      'privacy_security': 'Privacy & Security',
      'manage_permissions': 'Manage permissions and access',
      'help_support': 'Help & Support',
      'faqs_contact': 'FAQs or contact customer care',
      'logout': 'Logout',
      'sign_out': 'Sign out from your account',
      'version': 'Version 1.0.0 (Dark Edition)',
      'logout_confirm': 'Are you sure you want to logout?',

      // Language Selection
      'select_language': 'Select Language',
      'choose_language_message':
          'Choose your preferred language to continue using Krishi AI',
      'english': 'English',
      'hindi': 'हिन्दी',
      'marathi': 'मराठी',
      'active': 'Active',
      'change_language': 'CHANGE LANGUAGE',
      'change_anytime': 'You can change this anytime in Profile settings',

      // Login Screen
      'welcome_back': 'Welcome Back',
      'login_continue': 'Login to continue your harvest',
      'email': 'Email',
      'enter_email': 'Enter your email',
      'password': 'Password',
      'enter_password': 'Enter your password',
      'forgot_password': 'Forgot Password?',
      'login': 'Login',
      'dont_have_account': "Don't have an account?",
      'sign_up': 'Sign Up',
      'login_successful': 'Login Successful!',
      'login_failed': 'Login failed!',
      'enter_valid_credentials': 'Enter valid email & password',

      // Signup Screen
      'create_account': 'Create Account',
      'join_smart_farming': 'Join the future of smart farming.',
      'personal_information': 'PERSONAL INFORMATION',
      'full_name': 'Full Name',
      'eg_name': 'e.g. Rahul Sharma',
      'mobile_number': 'Mobile Number',
      'phone_placeholder': '+91 00000 00000',
      'email_address': 'Email Address',
      'email_placeholder': 'name@example.com',
      'create_password': 'Create Password',
      'farm_information': 'FARM INFORMATION',
      'create_my_account': 'Create My Account',
      'already_have_account': 'Already have an account?',
      'log_in': 'Log In',
      'signup_successful': 'Sign up successful!',
      'enter_valid_data': 'Enter valid data!',

      // Edit Profile
      'my_profile': 'My Profile',
      'personal_info': 'PERSONAL INFO',
      'phone_number': 'Phone Number',
      'farming_details': 'FARMING DETAILS',
      'primary_crop': 'Primary Crop',
      'farm_size': 'Farm Size (Acres)',
      'location': 'Location',
      'save_changes': 'Save Changes',
      'changes_saved': 'Changes Saved..!',

      // Camera Screen
      'scan_crop_disease': 'Scan Crop Disease',
      'choose_option': 'Choose an option',
      'take_photo': 'Take Photo',
      'choose_from_gallery': 'Choose from Gallery',
      'analyzing_crop': 'Analyzing Crop Disease...',
      'camera_permission_required': 'Camera Permission Required',
      'enable_camera_permission':
          'Please enable camera permission in settings to scan crop diseases.',
      'open_settings': 'Open Settings',
      'camera_permission_needed': 'Camera permission is required',

      // Detection Result
      'detection_result': 'Detection Result',
      'confidence': 'Confidence',
      'treatment': 'Treatment',
      'dosage': 'Dosage',
      'prevention': 'Prevention',
      'healthy_crop': 'Healthy Crop',
      'disease_detected': 'Disease Detected',

      // Bottom Navigation
      'home': 'Home',
      'market': 'Market',
      'scan': 'Scan',
      'weather_nav': 'Weather',
      'profile': 'Profile',

      // Initial Language Screen
      'change_anytime_profile':
          'You can change this anytime in Profile settings',

      // Tutorial
      'tutorial_scan_title': 'Scan Crop Disease',
      'tutorial_scan_desc':
          'Press here to capture crop image and detect diseases.',
      'tutorial_weather_title': 'Weather Forecast',
      'tutorial_weather_desc':
          'Check 5-day weather forecast for better farming decisions.',
      'tutorial_mandi_title': 'Market Prices',
      'tutorial_mandi_desc':
          'View live mandi prices to get best rates for your crops.',
      'tutorial_schemes_title': 'Government Schemes',
      'tutorial_schemes_desc':
          'Find government benefits and schemes available for farmers.',
      'tutorial_skip': 'Skip',
      'tutorial_next': 'Next',
      'tutorial_got_it': 'Got it!',
    },
    'hi_IN': {
      // Common
      'app_name': 'कृषि AI',
      'welcome': 'स्वागत है',
      'continue': 'जारी रखें',
      'cancel': 'रद्द करें',
      'save': 'सहेजें',
      'edit': 'संपादित करें',
      'delete': 'हटाएं',
      'confirm': 'पुष्टि करें',
      'yes': 'हाँ',
      'no': 'नहीं',
      'ok': 'ठीक है',
      'loading': 'लोड हो रहा है...',
      'error': 'त्रुटि',
      'success': 'सफलता',
      'retry': 'पुनः प्रयास करें',

      // Greetings
      'good_morning': 'सुप्रभात,',
      'good_afternoon': 'शुभ दोपहर,',
      'good_evening': 'शुभ संध्या,',
      'good_night': 'शुभ रात्रि,',

      // Home Screen
      'quick_actions': 'त्वरित कार्य',
      'edit_grid': 'ग्रिड संपादित करें',
      'scan_disease': 'रोग स्कैन करें',
      'detect_crop_issues': 'फसल समस्याओं का पता लगाएं',
      'advisory': 'सलाह',
      'ask_krishi_bot': 'कृषि बॉट से पूछें',
      'weather': 'मौसम',
      'five_day_forecast': '5-दिन का पूर्वानुमान',
      'mandi_prices': 'मंडी भाव',
      'live_market_rates': 'लाइव बाजार दरें',
      'schemes': 'योजनाएं',
      'govt_benefits': 'सरकारी लाभ',
      'history': 'इतिहास',
      'past_scans_data': 'पिछले स्कैन और डेटा',
      'press_back_again': 'बाहर निकलने के लिए फिर से बैक दबाएं',

      // Weather
      'humidity': 'नमी',
      'wind': 'हवा',
      'rain': 'बारिश',
      'aqi_good': 'AQI 45 (अच्छा)',

      // Profile Settings
      'profile_settings': 'प्रोफ़ाइल सेटिंग्स',
      'edit_profile': 'प्रोफ़ाइल संपादित करें',
      'change_name_photo': 'अपना नाम, फोटो या फोन नंबर बदलें',
      'notifications': 'सूचनाएं',
      'manage_alert_preferences': 'अपनी अलर्ट प्राथमिकताएं प्रबंधित करें',
      'language': 'भाषा',
      'select_preferred_language': 'पसंदीदा ऐप भाषा चुनें',
      'privacy_security': 'गोपनीयता और सुरक्षा',
      'manage_permissions': 'अनुमतियां और पहुंच प्रबंधित करें',
      'help_support': 'सहायता और समर्थन',
      'faqs_contact': 'FAQ या ग्राहक सेवा से संपर्क करें',
      'logout': 'लॉगआउट',
      'sign_out': 'अपने खाते से साइन आउट करें',
      'version': 'संस्करण 1.0.0 (डार्क संस्करण)',
      'logout_confirm': 'क्या आप वाकई लॉगआउट करना चाहते हैं?',

      // Language Selection
      'select_language': 'भाषा चुनें',
      'choose_language_message':
          'कृषि AI का उपयोग जारी रखने के लिए अपनी पसंदीदा भाषा चुनें',
      'english': 'English',
      'hindi': 'हिन्दी',
      'marathi': 'मराठी',
      'active': 'सक्रिय',
      'change_language': 'भाषा बदलें',
      'change_anytime': 'आप इसे प्रोफ़ाइल सेटिंग्स में कभी भी बदल सकते हैं',

      // Login Screen
      'welcome_back': 'वापसी पर स्वागत है',
      'login_continue': 'अपनी फसल जारी रखने के लिए लॉगिन करें',
      'email': 'ईमेल',
      'enter_email': 'अपना ईमेल दर्ज करें',
      'password': 'पासवर्ड',
      'enter_password': 'अपना पासवर्ड दर्ज करें',
      'forgot_password': 'पासवर्ड भूल गए?',
      'login': 'लॉगिन',
      'dont_have_account': 'खाता नहीं है?',
      'sign_up': 'साइन अप करें',
      'login_successful': 'लॉगिन सफल!',
      'login_failed': 'लॉगिन विफल!',
      'enter_valid_credentials': 'मान्य ईमेल और पासवर्ड दर्ज करें',

      // Signup Screen
      'create_account': 'खाता बनाएं',
      'join_smart_farming': 'स्मार्ट खेती के भविष्य में शामिल हों।',
      'personal_information': 'व्यक्तिगत जानकारी',
      'full_name': 'पूरा नाम',
      'eg_name': 'उदा. राहुल शर्मा',
      'mobile_number': 'मोबाइल नंबर',
      'phone_placeholder': '+91 00000 00000',
      'email_address': 'ईमेल पता',
      'email_placeholder': 'name@example.com',
      'create_password': 'पासवर्ड बनाएं',
      'farm_information': 'खेत की जानकारी',
      'create_my_account': 'मेरा खाता बनाएं',
      'already_have_account': 'पहले से खाता है?',
      'log_in': 'लॉग इन करें',
      'signup_successful': 'साइन अप सफल!',
      'enter_valid_data': 'मान्य डेटा दर्ज करें!',

      // Edit Profile
      'my_profile': 'मेरी प्रोफ़ाइल',
      'personal_info': 'व्यक्तिगत जानकारी',
      'phone_number': 'फोन नंबर',
      'farming_details': 'खेती का विवरण',
      'primary_crop': 'मुख्य फसल',
      'farm_size': 'खेत का आकार (एकड़)',
      'location': 'स्थान',
      'save_changes': 'परिवर्तन सहेजें',
      'changes_saved': 'परिवर्तन सहेजे गए..!',

      // Camera Screen
      'scan_crop_disease': 'फसल रोग स्कैन करें',
      'choose_option': 'एक विकल्प चुनें',
      'take_photo': 'फोटो लें',
      'choose_from_gallery': 'गैलरी से चुनें',
      'analyzing_crop': 'फसल रोग का विश्लेषण हो रहा है...',
      'camera_permission_required': 'कैमरा अनुमति आवश्यक',
      'enable_camera_permission':
          'फसल रोगों को स्कैन करने के लिए कृपया सेटिंग्स में कैमरा अनुमति सक्षम करें।',
      'open_settings': 'सेटिंग्स खोलें',
      'camera_permission_needed': 'कैमरा अनुमति आवश्यक है',

      // Detection Result
      'detection_result': 'पहचान परिणाम',
      'confidence': 'विश्वास',
      'treatment': 'उपचार',
      'dosage': 'खुराक',
      'prevention': 'रोकथाम',
      'healthy_crop': 'स्वस्थ फसल',
      'disease_detected': 'रोग का पता चला',

      // Bottom Navigation
      'home': 'होम',
      'market': 'बाजार',
      'scan': 'स्कैन',
      'weather_nav': 'मौसम',
      'profile': 'प्रोफ़ाइल',

      // Initial Language Screen
      'change_anytime_profile':
          'आप इसे प्रोफ़ाइल सेटिंग्स में कभी भी बदल सकते हैं',

      // Tutorial
      'tutorial_scan_title': 'फसल रोग स्कैन करें',
      'tutorial_scan_desc':
          'फसल की तस्वीर लेने और रोगों का पता लगाने के लिए यहां दबाएं।',
      'tutorial_weather_title': 'मौसम पूर्वानुमान',
      'tutorial_weather_desc':
          'बेहतर खेती के फैसलों के लिए 5-दिन का मौसम पूर्वानुमान देखें।',
      'tutorial_mandi_title': 'बाजार भाव',
      'tutorial_mandi_desc':
          'अपनी फसलों के लिए सर्वोत्तम दरें पाने के लिए लाइव मंडी भाव देखें।',
      'tutorial_schemes_title': 'सरकारी योजनाएं',
      'tutorial_schemes_desc':
          'किसानों के लिए उपलब्ध सरकारी लाभ और योजनाएं खोजें।',
      'tutorial_skip': 'छोड़ें',
      'tutorial_next': 'अगला',
      'tutorial_got_it': 'समझ गया!',
    },
    'mr_IN': {
      // Common
      'app_name': 'कृषी AI',
      'welcome': 'स्वागत आहे',
      'continue': 'सुरू ठेवा',
      'cancel': 'रद्द करा',
      'save': 'जतन करा',
      'edit': 'संपादित करा',
      'delete': 'हटवा',
      'confirm': 'पुष्टी करा',
      'yes': 'होय',
      'no': 'नाही',
      'ok': 'ठीक आहे',
      'loading': 'लोड होत आहे...',
      'error': 'त्रुटी',
      'success': 'यश',
      'retry': 'पुन्हा प्रयत्न करा',

      // Greetings
      'good_morning': 'सुप्रभात,',
      'good_afternoon': 'शुभ दुपार,',
      'good_evening': 'शुभ संध्याकाळ,',
      'good_night': 'शुभ रात्री,',

      // Home Screen
      'quick_actions': 'द्रुत क्रिया',
      'edit_grid': 'ग्रिड संपादित करा',
      'scan_disease': 'रोग स्कॅन करा',
      'detect_crop_issues': 'पीक समस्या शोधा',
      'advisory': 'सल्ला',
      'ask_krishi_bot': 'कृषी बॉटला विचारा',
      'weather': 'हवामान',
      'five_day_forecast': '5-दिवसांचा अंदाज',
      'mandi_prices': 'मंडी भाव',
      'live_market_rates': 'थेट बाजार दर',
      'schemes': 'योजना',
      'govt_benefits': 'सरकारी लाभ',
      'history': 'इतिहास',
      'past_scans_data': 'मागील स्कॅन आणि डेटा',
      'press_back_again': 'बाहेर पडण्यासाठी पुन्हा बॅक दाबा',

      // Weather
      'humidity': 'आर्द्रता',
      'wind': 'वारा',
      'rain': 'पाऊस',
      'aqi_good': 'AQI 45 (चांगले)',

      // Profile Settings
      'profile_settings': 'प्रोफाइल सेटिंग्ज',
      'edit_profile': 'प्रोफाइल संपादित करा',
      'change_name_photo': 'तुमचे नाव, फोटो किंवा फोन नंबर बदला',
      'notifications': 'सूचना',
      'manage_alert_preferences': 'तुमच्या सूचना प्राधान्यक्रम व्यवस्थापित करा',
      'language': 'भाषा',
      'select_preferred_language': 'पसंतीची अॅप भाषा निवडा',
      'privacy_security': 'गोपनीयता आणि सुरक्षा',
      'manage_permissions': 'परवानग्या आणि प्रवेश व्यवस्थापित करा',
      'help_support': 'मदत आणि समर्थन',
      'faqs_contact': 'FAQ किंवा ग्राहक सेवेशी संपर्क साधा',
      'logout': 'लॉगआउट',
      'sign_out': 'तुमच्या खात्यातून साइन आउट करा',
      'version': 'आवृत्ती 1.0.0 (डार्क आवृत्ती)',
      'logout_confirm': 'तुम्हाला खरोखर लॉगआउट करायचे आहे का?',

      // Language Selection
      'select_language': 'भाषा निवडा',
      'choose_language_message':
          'कृषी AI वापरणे सुरू ठेवण्यासाठी तुमची पसंतीची भाषा निवडा',
      'english': 'English',
      'hindi': 'हिन्दी',
      'marathi': 'मराठी',
      'active': 'सक्रिय',
      'change_language': 'भाषा बदला',
      'change_anytime': 'तुम्ही हे प्रोफाइल सेटिंग्जमध्ये कधीही बदलू शकता',

      // Login Screen
      'welcome_back': 'परत स्वागत आहे',
      'login_continue': 'तुमची शेती सुरू ठेवण्यासाठी लॉगिन करा',
      'email': 'ईमेल',
      'enter_email': 'तुमचा ईमेल प्रविष्ट करा',
      'password': 'पासवर्ड',
      'enter_password': 'तुमचा पासवर्ड प्रविष्ट करा',
      'forgot_password': 'पासवर्ड विसरलात?',
      'login': 'लॉगिन',
      'dont_have_account': 'खाते नाही?',
      'sign_up': 'साइन अप करा',
      'login_successful': 'लॉगिन यशस्वी!',
      'login_failed': 'लॉगिन अयशस्वी!',
      'enter_valid_credentials': 'वैध ईमेल आणि पासवर्ड प्रविष्ट करा',

      // Signup Screen
      'create_account': 'खाते तयार करा',
      'join_smart_farming': 'स्मार्ट शेतीच्या भविष्यात सामील व्हा.',
      'personal_information': 'वैयक्तिक माहिती',
      'full_name': 'पूर्ण नाव',
      'eg_name': 'उदा. राहुल शर्मा',
      'mobile_number': 'मोबाइल नंबर',
      'phone_placeholder': '+91 00000 00000',
      'email_address': 'ईमेल पत्ता',
      'email_placeholder': 'name@example.com',
      'create_password': 'पासवर्ड तयार करा',
      'farm_information': 'शेताची माहिती',
      'create_my_account': 'माझे खाते तयार करा',
      'already_have_account': 'आधीपासून खाते आहे?',
      'log_in': 'लॉग इन करा',
      'signup_successful': 'साइन अप यशस्वी!',
      'enter_valid_data': 'वैध डेटा प्रविष्ट करा!',

      // Edit Profile
      'my_profile': 'माझी प्रोफाइल',
      'personal_info': 'वैयक्तिक माहिती',
      'phone_number': 'फोन नंबर',
      'farming_details': 'शेतीचा तपशील',
      'primary_crop': 'मुख्य पीक',
      'farm_size': 'शेताचा आकार (एकर)',
      'location': 'स्थान',
      'save_changes': 'बदल जतन करा',
      'changes_saved': 'बदल जतन केले..!',

      // Camera Screen
      'scan_crop_disease': 'पीक रोग स्कॅन करा',
      'choose_option': 'एक पर्याय निवडा',
      'take_photo': 'फोटो घ्या',
      'choose_from_gallery': 'गॅलरीमधून निवडा',
      'analyzing_crop': 'पीक रोगाचे विश्लेषण करत आहे...',
      'camera_permission_required': 'कॅमेरा परवानगी आवश्यक',
      'enable_camera_permission':
          'पीक रोग स्कॅन करण्यासाठी कृपया सेटिंग्जमध्ये कॅमेरा परवानगी सक्षम करा.',
      'open_settings': 'सेटिंग्ज उघडा',
      'camera_permission_needed': 'कॅमेरा परवानगी आवश्यक आहे',

      // Detection Result
      'detection_result': 'शोध परिणाम',
      'confidence': 'विश्वास',
      'treatment': 'उपचार',
      'dosage': 'डोस',
      'prevention': 'प्रतिबंध',
      'healthy_crop': 'निरोगी पीक',
      'disease_detected': 'रोग आढळला',

      // Bottom Navigation
      'home': 'होम',
      'market': 'बाजार',
      'scan': 'स्कॅन',
      'weather_nav': 'हवामान',
      'profile': 'प्रोफाइल',

      // Initial Language Screen
      'change_anytime_profile':
          'तुम्ही हे प्रोफाइल सेटिंग्जमध्ये कधीही बदलू शकता',

      // Tutorial
      'tutorial_scan_title': 'पीक रोग स्कॅन करा',
      'tutorial_scan_desc':
          'पिकाचा फोटो घेण्यासाठी आणि रोग शोधण्यासाठी येथे दाबा.',
      'tutorial_weather_title': 'हवामान अंदाज',
      'tutorial_weather_desc':
          'चांगल्या शेती निर्णयांसाठी 5-दिवसांचा हवामान अंदाज पहा.',
      'tutorial_mandi_title': 'बाजार भाव',
      'tutorial_mandi_desc':
          'तुमच्या पिकांसाठी सर्वोत्तम दर मिळवण्यासाठी थेट मंडी भाव पहा.',
      'tutorial_schemes_title': 'सरकारी योजना',
      'tutorial_schemes_desc':
          'शेतकऱ्यांसाठी उपलब्ध सरकारी लाभ आणि योजना शोधा.',
      'tutorial_skip': 'वगळा',
      'tutorial_next': 'पुढे',
      'tutorial_got_it': 'समजले!',
    },
  };
}

# 🌾 Krishi AI — Smart Farming Assistant

Krishi AI is a full-stack AI-powered mobile application built for Indian farmers. It combines a **Flutter** mobile frontend with a **Python Flask** backend to deliver intelligent agricultural tools including crop disease detection, real-time market prices, weather-based farming advisories, government scheme discovery, land measurement, and a conversational AI chatbot — all available in English, Hindi, and Marathi.

---

## 📑 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Architecture & How It Works](#architecture--how-it-works)
  - [Frontend (Flutter)](#frontend-flutter)
  - [Backend (Python Flask)](#backend-python-flask)
- [API Endpoints](#api-endpoints)
- [Setup & Installation](#setup--installation)
  - [Backend Setup](#backend-setup)
  - [Frontend Setup](#frontend-setup)
- [Environment Variables](#environment-variables)
- [Deployment](#deployment)
- [Supported Languages](#supported-languages)
- [Crop Disease Detection Model](#crop-disease-detection-model)
- [Screenshots](#screenshots)

---

## Overview

Krishi AI bridges the gap between modern AI technology and the needs of small-scale Indian farmers. Using Google's **Gemini AI** model and on-device **TensorFlow Lite** inference, the app empowers farmers to:

- Instantly identify crop diseases from a photograph
- Get AI-generated treatment recommendations
- Check live mandi (market) prices for their commodities
- Receive weather-based crop cultivation advice
- Discover government welfare schemes they are eligible for
- Find nearby agricultural supply stores
- Measure farmland area using an interactive map
- Chat with an AI agriculture expert in their native language

---

## Features

### 🔬 Crop Disease Detection (Dual-Mode)
- **On-device TFLite model**: Runs locally on the device for fast, offline-capable inference on 15 plant disease classes (Tomato, Potato, Bell Pepper)
- **Cloud AI via Gemini**: Falls back to Google Gemini 2.5 Flash for richer, image-based diagnosis with detailed disease name, cure, and confidence level
- Supports both camera capture and gallery upload
- Returns: disease name, treatment/cure, confidence (`low | medium | high`)

**Detectable diseases (on-device model):**
| Crop | Disease Classes |
|------|----------------|
| Tomato | Bacterial Spot, Early Blight, Late Blight, Leaf Mold, Septoria Leaf Spot, Spider Mites, Target Spot, Yellow Leaf Curl Virus, Mosaic Virus, Healthy |
| Potato | Early Blight, Late Blight, Healthy |
| Bell Pepper | Bacterial Spot, Healthy |

---

### 💬 AI Agriculture Chatbot
- Powered by **Gemini 2.5 Flash** with a system prompt tuned for farming advice
- Maintains full conversation history for context-aware multi-turn dialogue
- Gives practical, low-cost, step-by-step advice in simple language
- Accessible as a floating overlay from any screen in the app

---

### 📈 Live Mandi / Market Prices
- Fetches current agricultural commodity prices using Gemini AI with Google Search grounding
- Filter by location and commodity (e.g., tomato, onion, potato, rice, wheat)
- Displays: commodity, variety, unit, min/max/modal price, market name, price trend (rising/falling/stable)
- Prices shown in Indian Rupees (₹) per quintal or per kg

---

### 🌦 Weather-Based Crop Advisory
- Integrates **WeatherAPI** (5-day forecast) with Gemini AI analysis
- Input: city/state name; auto-detects location via GPS
- Output includes:
  - Weather summary for farming context
  - Recommended crops with suitability ratings
  - Actionable farm tasks (e.g., irrigation, harvesting windows)
  - Risk alerts (frost, excessive rain, drought)
  - Additional farming suggestions

---

### 🏛 Government Schemes Finder
- Uses Gemini AI with Google Search to find up-to-date Indian government schemes for farmers
- Filter by state and scheme type (subsidy, loan, insurance, etc.)
- Returns: scheme name, summary, eligibility, benefits list, how-to-apply steps, and official links
- Covers both central and state government programs

---

### 🗺 Land Measurement Tool
- Interactive map-based land area calculator
- Tap to place boundary points around your farm on an OpenStreetMap / satellite view
- Calculates area in real-time using the Shoelace (Gauss) formula applied to GPS coordinates
- Displays area in square meters, acres, and hectares
- Toggle between street map and satellite imagery

---

### 🏪 Nearby Agricultural Stores
- Finds pesticide shops, fertilizer dealers, and farming supply stores near the user's GPS location
- Uses Gemini AI with Google Search for real store data
- Shows: store name, address, distance, phone number, rating, and open/closed status

---

### 👤 User Authentication & Profiles
- **Firebase Authentication**: Email/password sign-up and login
- **Cloud Firestore**: Stores user profile data (name, phone, farm size, primary crop, location)
- Edit profile with personal and farming details
- Persistent session across app restarts

---

### 🌐 Multi-Language Support
- **Three languages supported**: English (en_US), Hindi (hi_IN), Marathi (mr_IN)
- Real-time language switching without app restart
- Language preference persisted via SharedPreferences
- All core UI screens translated: Home, Login, Signup, Camera, Profile, Language Settings

---

### 🎓 Interactive Tutorial
- First-launch coach mark tutorial using `tutorial_coach_mark`
- Guides new users through key features: Scan Disease, Weather, Mandi Prices, and Government Schemes
- Skip and Next controls, with scroll-aware step triggering
- Tutorial state persisted so it only shows once

---

### 🔖 Caching
- Local response caching via `cache_service.dart` to reduce redundant API calls
- Improves performance for weather and market price data

---

## Tech Stack

### Frontend
| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x (Dart) |
| State Management | GetX |
| Authentication | Firebase Auth |
| Database | Cloud Firestore |
| On-device ML | TensorFlow Lite (`tflite_flutter`) |
| Maps | flutter_map + OpenStreetMap |
| Location | geolocator + geocoding |
| Camera | image_picker |
| HTTP | http, http_parser |
| UI | google_fonts, curved_navigation_bar, weather_icons |
| Internationalization | GetX Translations |
| Tutorial | tutorial_coach_mark |
| Storage | shared_preferences |
| Logging | logger |

### Backend
| Layer | Technology |
|-------|-----------|
| Framework | Python Flask |
| AI Model | Google Gemini 2.5 Flash (via REST API) |
| Search Grounding | Gemini Google Search tool |
| Weather Data | WeatherAPI.com |
| CORS | flask-cors |
| Config | python-dotenv |
| Server | Gunicorn (production), Waitress (Windows) |
| Deployment | Render.com |

---

## Project Structure

```
Krishi-AI/
├── backend/
│   ├── app.py                    # Flask application with all API endpoints
│   ├── wsgi.py                   # WSGI entry point
│   ├── requirements.txt          # Python dependencies
│   ├── render.yaml               # Render deployment configuration
│   └── API_DOCUMENTATION.md     # Detailed API reference
│
└── frontend/
    └── krishi_ai/
        ├── lib/
        │   ├── main.dart                    # App entry point, Firebase + TFLite init
        │   ├── View/
        │   │   ├── spalsh_screen.dart       # Splash / loading screen
        │   │   ├── login_screen.dart        # Firebase email login
        │   │   ├── signup_screen.dart       # User registration
        │   │   ├── home_screen.dart         # Main dashboard with weather widget
        │   │   ├── bottom_nav_bar.dart      # Bottom navigation (Home/Market/Scan/Weather/Profile)
        │   │   ├── camera_screen.dart       # Crop image capture & upload
        │   │   ├── detection_screen.dart    # Disease detection result display
        │   │   ├── market_screen.dart       # Mandi prices screen
        │   │   ├── weather_advisory_screen.dart  # Weather + crop advisory
        │   │   ├── gov_schemes_screen.dart  # Government schemes finder
        │   │   ├── land_measure_screen.dart # GPS-based land area calculator
        │   │   ├── profile_setting.dart     # Profile settings menu
        │   │   ├── edit_profile.dart        # Edit user profile
        │   │   ├── language_screen.dart     # Language selection (first launch)
        │   │   ├── change_language.dart     # Language switcher (settings)
        │   │   ├── help_support_screen.dart # FAQs and support
        │   │   └── privacy_security_screen.dart  # Privacy settings
        │   ├── services/
        │   │   ├── api_service.dart              # Base HTTP client
        │   │   ├── crop_detection_service.dart   # TFLite + backend disease detection
        │   │   ├── chatbot_service.dart           # Chatbot API integration
        │   │   ├── market_prices_service.dart     # Market price API calls
        │   │   ├── weather_advisory_service.dart  # Weather + advisory API calls
        │   │   ├── gov_schemes_service.dart       # Government schemes API calls
        │   │   ├── nearby_stores_service.dart     # Nearby stores API calls
        │   │   └── cache_service.dart             # Local response caching
        │   ├── widgets/
        │   │   ├── chatbot_overlay.dart    # Floating chatbot UI
        │   │   └── chatbot_wrapper.dart    # Chatbot state wrapper
        │   ├── translations/
        │   │   └── app_translations.dart   # English, Hindi, Marathi strings
        │   ├── controllers/
        │   │   └── language_controller.dart  # GetX language state controller
        │   └── utils/
        │       └── tutorial_helper.dart    # First-launch tutorial logic
        ├── assets/
        │   ├── model.tflite          # On-device TensorFlow Lite crop disease model
        │   ├── labels.txt            # Disease class labels (15 classes)
        │   └── disease_info.json     # Treatment & info for each disease class
        └── pubspec.yaml              # Flutter dependencies
```

---

## Architecture & How It Works

### Frontend (Flutter)

```
User Opens App
     │
     ▼
SplashScreen
     │
     ├─── First Launch? ──► LanguageScreen (pick English/Hindi/Marathi)
     │
     ▼
LoginScreen / SignupScreen (Firebase Auth)
     │
     ▼
KrishiAIDashboard (HomeScreen)
     │
     ├── Weather Widget (auto-fetches GPS location → WeatherAPI → Gemini advisory)
     │
     ├── Quick Action Grid:
     │     ├── Scan Disease ──► CameraScreen ──► CropDetectionService
     │     │                                        ├── TFLite (on-device, fast)
     │     │                                        └── Gemini API (cloud, detailed)
     │     │                    ──► DetectionScreen (results)
     │     │
     │     ├── Weather ──────► WeatherAdvisoryScreen (5-day + crop advice)
     │     ├── Mandi Prices ─► MarketScreen (commodity prices by location)
     │     └── Schemes ──────► GovSchemesScreen (filter by state & type)
     │
     └── Bottom Navigation:
           ├── Home
           ├── Market (Mandi Prices)
           ├── Scan (Crop Disease)
           ├── Weather (Advisory)
           └── Profile (Settings, Language, Logout)

Floating Chatbot Overlay ──► ChatbotService ──► Backend /chatbot endpoint
Land Measurement ──────────► LandMeasureScreen (GPS + Map + Area calculation)
```

**Key design decisions:**
- **Dual detection strategy**: On-device TFLite for speed and offline support; cloud Gemini for richer analysis
- **GetX** for lightweight reactive state management and built-in i18n
- **Firebase** for production-grade auth and user data storage
- **flutter_map** with OpenStreetMap tiles for open-source mapping (no Google Maps API key required)

---

### Backend (Python Flask)

Every endpoint follows this pattern:
1. Validate request body
2. Build a structured prompt with JSON schema specification
3. Call Gemini 2.5 Flash (optionally with Google Search grounding)
4. Parse and validate the JSON response
5. Return structured data or graceful error fallback

```
Flutter App ──HTTP POST──► Flask API (Render.com)
                               │
                        ┌──────┼──────────────────┐
                        ▼      ▼                  ▼
                   Gemini AI  WeatherAPI    Google Search
                  (via REST)  (forecast)   (grounding tool)
```

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/` | Health check |
| `GET` | `/test-api-keys` | Verify Gemini & Weather API keys |
| `POST` | `/detect-disease` | Crop disease detection from image |
| `POST` | `/chatbot` | AI agriculture chatbot with history |
| `POST` | `/gov-schemes` | Find government schemes for farmers |
| `POST` | `/weather-crop-advisory` | 5-day weather forecast + crop advisory |
| `POST` | `/market-prices` | Live mandi / market commodity prices |
| `POST` | `/nearby-stores` | Find nearby agricultural supply stores |

### Request / Response Examples

**`POST /detect-disease`**
```
Form-data: file=<image file>
Response: { "disease": "Tomato Early Blight", "cure": "Apply copper-based fungicide...", "confidence": "high" }
```

**`POST /chatbot`**
```json
{ "message": "My tomato leaves are turning yellow", "history": [] }
→ { "reply": "Yellow leaves in tomatoes can indicate..." }
```

**`POST /weather-crop-advisory`**
```json
{ "city": "Pune", "state": "Maharashtra", "country": "IN" }
→ { "location": {...}, "forecast": [...], "advisory": { "recommended_crops": [...], "farm_actions": [...] } }
```

**`POST /market-prices`**
```json
{ "location": "Pune", "commodity": "tomato" }
→ { "location": "Pune", "prices": [{ "commodity": "Tomato", "modal_price": 1800, "trend": "rising", ... }] }
```

**`POST /gov-schemes`**
```json
{ "state": "Maharashtra", "type": "subsidy" }
→ { "schemes": [{ "name": "PM-KISAN", "eligibility": "...", "benefits": [...], ... }] }
```

**`POST /nearby-stores`**
```json
{ "latitude": 18.52, "longitude": 73.85, "city": "Pune", "state": "Maharashtra" }
→ { "stores": [{ "name": "Agro Supplies", "distance": "1.2 km", "phone": "+91 ...", ... }] }
```

---

## Setup & Installation

### Backend Setup

**Prerequisites:** Python 3.12+

```bash
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate   # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Configure environment variables
cp .env.example .env
# Edit .env and add your API keys (see Environment Variables section)

# Run the development server
python app.py

# Or with Gunicorn (production)
gunicorn app:app --bind 0.0.0.0:8000 --workers 1 --timeout 180
```

The backend will be available at `http://localhost:8000`.

---

### Frontend Setup

**Prerequisites:** Flutter SDK 3.x, Android Studio or Xcode

```bash
cd frontend/krishi_ai

# Install Flutter dependencies
flutter pub get

# Configure Firebase
# - Create a Firebase project at https://console.firebase.google.com
# - Enable Authentication (Email/Password) and Firestore
# - Add your Android app and download google-services.json
# - Place google-services.json in android/app/
# - Update Firebase options in lib/main.dart

# Update backend URL
# In lib/services/crop_detection_service.dart, update backendUrl to your backend URL

# Run on connected device / emulator
flutter run

# Build release APK
flutter build apk --release
```

---

## Environment Variables

Create a `.env` file in the `backend/` directory:

```env
# Google Gemini API Key (required)
# Get from: https://aistudio.google.com/app/apikey
GEMINI_API_KEY=your_gemini_api_key_here

# WeatherAPI Key (required for weather advisory)
# Get from: https://www.weatherapi.com/
WEATHER_API_KEY=your_weatherapi_key_here

# Port (optional, defaults to environment PORT or 8000)
PORT=8000
```

---

## Deployment

### Backend — Render.com

The backend is configured for one-click deployment on [Render.com](https://render.com) via `backend/render.yaml`:

```yaml
services:
  - type: web
    name: mor-backend
    env: python
    buildCommand: pip install -r requirements.txt
    startCommand: gunicorn app:app --bind 0.0.0.0:$PORT --workers 1 --timeout 180
```

**Steps:**
1. Push the repository to GitHub
2. Create a new Web Service on Render pointing to the `backend/` directory
3. Set `GEMINI_API_KEY` and `WEATHER_API_KEY` in Render's environment variables
4. Deploy — Render will auto-build and serve the API

### Frontend — Android APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

For Google Play Store, use:
```bash
flutter build appbundle --release
```

---

## Supported Languages

| Language | Code | Script |
|----------|------|--------|
| English | `en_US` | Latin |
| Hindi | `hi_IN` | Devanagari |
| Marathi | `mr_IN` | Devanagari |

Language is selected on first launch and can be changed anytime via **Profile → Language**. The preference is saved locally and persists across app restarts.

---

## Crop Disease Detection Model

The on-device TFLite model (`assets/model.tflite`) is a convolutional neural network trained on the [PlantVillage dataset](https://github.com/spMohanty/PlantVillage-Dataset) and classifies 15 classes:

| # | Class Label |
|---|------------|
| 1 | Pepper Bell — Bacterial Spot |
| 2 | Pepper Bell — Healthy |
| 3 | Potato — Early Blight |
| 4 | Potato — Late Blight |
| 5 | Potato — Healthy |
| 6 | Tomato — Bacterial Spot |
| 7 | Tomato — Early Blight |
| 8 | Tomato — Late Blight |
| 9 | Tomato — Leaf Mold |
| 10 | Tomato — Septoria Leaf Spot |
| 11 | Tomato — Spider Mites (Two-spotted) |
| 12 | Tomato — Target Spot |
| 13 | Tomato — Yellow Leaf Curl Virus |
| 14 | Tomato — Mosaic Virus |
| 15 | Tomato — Healthy |

Detailed treatment information for each class (cure, dosage, prevention) is loaded from `assets/disease_info.json` and shown in the detection result screen.

---

## Screenshots

> _Coming soon — run the app locally to see the UI in action._

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit changes: `git commit -m "Add your feature"`
4. Push: `git push origin feature/your-feature`
5. Open a Pull Request

---

## License

This project is for educational and non-commercial use. See individual library licenses for third-party dependencies.

---

*Built with ❤️ for Indian farmers — Jai Kisan! 🌾*
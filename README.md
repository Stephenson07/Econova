# Econova - All your E-waste solutions at one place

- This repo contains the Frontend code, for backend kindly visit [Backend Repository](https://github.com/Stephenson07/Backend)

# Overview
- EcoNova is a comprehensive mobile app designed to promote sustainable e-waste management and reduce its environmental impact through responsible recycling practices. By integrating gamification, our platform makes recycling both engaging and rewarding. Users participate in community-driven activities, events, and friendly competitions, earning credits for recycling e-waste, which can be exchanged for a variety of gifts. This approach encourages greater user involvement in e-waste recycling.

- The app features a scan functionality that provides detailed information about electronic components, helping users make informed recycling decisions. It also offers a dedicated marketplace for users to sell their electronics, ensuring they are reused or properly recycled. Additionally, users can schedule pickups for their e-waste, which is collected directly from their location and delivered to recycling plants. The app includes a progress dashboard, allowing users to track their contributions and see the positive environmental impact they’re making. EcoNova also fosters community engagement by offering various communities that users can join, along with an events tab to stay updated on upcoming e-waste initiatives. The app empowers users to report illegal e-waste disposal activities, such as the burning of electronics, to authorities, ensuring responsible recycling practices.

# Features
## Smart Component Intelligence
- Advanced E-waste capturing technology that provides instant, comprehensive insights into electronic devices, enabling informed recycling decisions through deep technological analysis.
Circular Economy Marketplace
- A purpose-built platform connecting users with opportunities to resell, recycle, and responsibly dispose of electronic devices, minimizing waste and maximizing resource utilization.
Seamless Recycling Infrastructure

## One-tap e-waste collection scheduling
- Direct pickup and professional recycling plant integration
Geo-optimized collection routing

## Impact Visualization
- Personalized environmental impact dashboard presenting: Monthly recycling progress, Recycling breakdowns, Environmental Impacts

## Incentive Ecosystem
- Innovative reward mechanism that transforms sustainable actions into tangible benefits, motivating continuous environmental engagement through credits accumulation

## Community Empowerment
- Collaborative environmental networks
- Event discovery and participation
- Responsible disposal advocacy platform

## Ethical Monitoring
- User-driven reporting system for identifying and addressing improper electronic waste disposal, supporting local environmental regulations and sustainable practices.

#  Technologies Used
- Flutter
- Flask
- Firebase
- Gemini API
- IDX

# Prerequisites
## Development Environment

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code or IDX
- Git
- Python

# 🚀 Installation Guide
## 1. Clone the Repository
```bash
# Clone the repository
git clone https://github.com/Stephenson07/Econova

# Navigate to the project directory
cd Econova
```

### 2. Set Up Firebase
1. Download `google-services.json` for Android
   - Go to Firebase Console
   - Select your project
   - Add Android app
   - Download configuration file
   - Place in `android/app/` directory

2. Download `GoogleService-Info.plist` for iOS
   - Go to Firebase Console
   - Select your project
   - Add iOS app
   - Download configuration file
   - Place in `ios/Runner/` directory

## 3. Install Dependencies
```bash
# Get Flutter dependencies
flutter pub get

# Configure Firebase (if not automatically configured)
flutterfire configure
```

## 5. Backend Setup
- For backend kindly visit [Backend Repository](https://github.com/Stephenson07/Backend)

### 6. Run the Application
```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Web
flutter run -d edge
```

### 7. Build for Production
```bash
# Android APK
flutter build apk --release

# iOS IPA
flutter build ios

# Web
flutter build web
```

### Troubleshooting
- Ensure all API keys are correctly configured
- Check Firebase and Gemini API connectivity
- Verify Flask server is running
- Update Flutter and Dart to latest versions

### Recommended Development Workflow
1. Pull latest changes
2. Install/update dependencies
3. Configure environment variables
4. Start Flask backend
5. Run Flutter app
6. Test and develop

# Screenshots
# Project Structure
```
├── lib/
│   ├── main.dart
│   ├── firebase.dart
│   ├── firebase_options.dart
│   ├── screens/
│   │   ├── addblog_screen.dart
│   │   ├── cart.dart
│   │   ├── cart_screen.dart
│   │   ├── contact_screen.dart
│   │   ├── create_group_screen.dart
│   │   ├── credits_screen.dart
│   │   ├── dashboard.dart
│   │   ├── events_screen.dart
│   │   ├── groups_screen.dart
│   │   ├── home_screen.dart
│   │   ├── Product_Detail_Screen.dart
│   │   ├── report_screen.dart
│   │   ├── scan_screen.dart
│   │   ├── settings_screen.dart
│   │   ├── signin_screen.dart
│   │   ├── signup_screen.dart
│   │   └── store_screen.dart
│   ├── state/
│   │   ├── state.dart
│   └── widgets/
│       ├── action_buttons.dart
│       ├── activity_card.dart
│       ├── carousel_slider.dart
│       ├── custom_drawer.dart
│       └── feature.dart

```
# Dependencies
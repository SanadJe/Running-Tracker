# Running Tracker (Flutter + Firebase)

## Features
- Create runs
- Read statistics (Total Distance, Total Runs)
- Update run
- Delete run
- Search runs
- Light/Dark mode
- Firestore backend

## Tech Stack
- Flutter (Material 3)
- Provider (State Management)
- Firebase: Auth + Firestore
- iOS Simulator: iPhone 15 Pro Max

## Setup Instructions
1. Install Flutter SDK
2. Create Firebase project
3. Add iOS app with Bundle ID: com.mitchkono.gano
4. Download `GoogleService-Info.plist` and place it in:
   `ios/Runner/`
5. Run:
```bash
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter run

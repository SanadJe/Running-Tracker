# Running Tracker (Flutter + Firebase + Provider)

A simple Running Tracker app built with Flutter.  
It supports **Create / Read / Update / Delete runs**, shows **statistics** (total distance + total runs), includes **search**, and supports **Light/Dark mode**.  
Backend is **Firebase Authentication (Email/Password)** + **Cloud Firestore** with real-time updates.

---

## Features

### ✅ Runs (CRUD)
- **Create** a run (name, distance, time, description)
- **Read** runs list with live updates (Firestore stream)
- **Update** a run (edit screen)
- **Delete** a run (delete icon)

### ✅ Statistics
- **Total Distance**
- **Total Runs**

### ✅ Search
- Search runs by title/notes (without interrupting typing)

### ✅ UI/UX
- Material Design 3 (Theme + reusable widgets)
- Light / Dark mode toggle

### ✅ Backend
- Firebase Auth (Email/Password)
- Firestore structure per user

---

## Tech Stack

- Flutter (Material 3)
- Provider (state management)
- Firebase Authentication
- Cloud Firestore

## Project Structure (High-level)

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── colors.dart
│   │   └── text_styles.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── stat_card.dart
│       ├── empty_state.dart
│       └── section_title.dart
│
├── features/
│   ├── auth/
│   │   ├── provider/
│   │   │   └── auth_provider.dart
│   │   └── ui/
│   │       ├── auth_gate.dart
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   │
│   └── runs/
│       ├── models/
│       │   └── run_model.dart
│       ├── provider/
│       │   └── runs_provider.dart
│       └── ui/
│           ├── runs_screen.dart
│           ├── add_run_screen.dart
│           └── edit_run_screen.dart
│
└── main.dart
```

## Getting Started
Prerequisites
Flutter SDK (3.x or newer)
Dart SDK
Firebase account
Android Studio or VS Code
iOS Simulator or Android Emulator
Check Flutter installation: flutter doctor

##Installation & Setup
1️⃣ Clone Repository
git clone https://github.com/Sanadje/running-tracker.git
cd Running-Tracker
2️⃣ Install Dependencies
flutter pub get

## Firestore data structure 
``
users (collection)
 └── userId (document)
     └── runs (sub-collection)
         └── runId (document)
             ├── title: string
             ├── notes: string
             ├── distance: double
             ├── duration: int
             ├── createdAt: timestamp
             └── updatedAt: timestamp
             ``
             
## Firestore Security Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId}/runs/{runId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }
  }
}

## Authentication Flow
AuthGate decides which screen to show:
Logged in → RunsScreen
Not logged in → LoginScreen
Supported:
Register
Login
Logout

## State Management
AuthProvider → Authentication state
RunProvider → CRUD + Firestore stream
ThemeProvider → Light/Dark mode

## Performance Optimization
Lazy loading using ListView.builder
Real-time Firestore streams
Reduced bundle size by excluding Pods and Firebase config

## Known Limitations
Offline mode not implemented
Push notifications not included
Export features not included

## Author
Sanad Je
Mobile Application Development – Fall 2025

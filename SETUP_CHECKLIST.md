# ✅ Firebase Setup Checklist

## Pre-Setup
- [ ] Punya akun Google
- [ ] Buka https://console.firebase.google.com
- [ ] Siap download file konfigurasi

## Firebase Project
- [ ] Create Firebase Project
- [ ] Tunggu project selesai dibuat
- [ ] Enable Firestore Database
- [ ] Catat Project ID: `_________________`

## Firestore Database Setup
- [ ] Go to Firestore Database
- [ ] Click "Create Database"
- [ ] Select location: `asia-southeast1`
- [ ] Start in TEST MODE (for development)
- [ ] Update Security Rules:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /contacts/{document=**} {
      allow read, write: if request.auth == null;
    }
  }
}
```

- [ ] Click "Publish"

## Android Setup
- [ ] Go to Firebase Console → Project Settings
- [ ] Add Android app
- [ ] Package name: `com.example.flutter_application_2`
- [ ] Get SHA-1 certificate (optional tapi recommended)
- [ ] Download `google-services.json`
- [ ] Copy ke: `android/app/google-services.json`
- [ ] Check `android/build.gradle` punya:
  ```gradle
  classpath 'com.google.gms:google-services:4.3.15'
  ```
- [ ] Check `android/app/build.gradle` punya:
  ```gradle
  apply plugin: 'com.google.gms.google-services'
  ```

## iOS Setup
- [ ] Go to Firebase Console → Project Settings
- [ ] Add iOS app
- [ ] Bundle ID: `com.example.flutterApplication2`
- [ ] Download `GoogleService-Info.plist`
- [ ] Add ke Xcode (ios/Runner/):
  - Buka `ios/Runner.xcworkspace`
  - Drag file ke project
  - Select target `Runner`
  - Ensure "Copy items if needed" checked

## Update Firebase Options
- [ ] Open `lib/firebase_options.dart`
- [ ] Copy values dari Firebase Console:
  
**For Android:**
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: '1:SENDER_ID:android:HASH',
  messagingSenderId: 'SENDER_ID',
  projectId: 'your-project-id',
  databaseURL: 'https://your-project.firebaseio.com',
  storageBucket: 'your-project.appspot.com',
);
```

## Dependencies
- [ ] Run `flutter pub get`
- [ ] No errors dari pub get
- [ ] Check pubspec.yaml punya:
  ```yaml
  firebase_core: ^4.2.1
  cloud_firestore: ^6.1.0
  ```

## Local Testing
- [ ] Run: `flutter run`
- [ ] App buka tanpa error
- [ ] Home screen muncul (contact list)
- [ ] Klik `+` button
- [ ] Form muncul
- [ ] Isi all fields
- [ ] Klik "Simpan Kontak"
- [ ] Lihat notification "Kontak berhasil ditambahkan"
- [ ] Kontak muncul di list

## Firebase Console Verification
- [ ] Buka Firebase Console
- [ ] Go to Firestore Database
- [ ] Check collection "contacts" ada
- [ ] Verify data dari app ada di console
- [ ] Try add data langsung dari console
- [ ] Check auto-update di app (no refresh needed)

## Troubleshooting Checklist

### Build Error
- [ ] Run: `flutter clean`
- [ ] Run: `flutter pub get`
- [ ] Check google-services.json ada (Android)
- [ ] Check GoogleService-Info.plist ada (iOS)

### Firebase Connection Error
- [ ] Check internet connection
- [ ] Verify firebase_options.dart config benar
- [ ] Verify Firestore Database active di console
- [ ] Check Security Rules allow read/write

### Permission Denied
- [ ] Open Firestore → Security Rules
- [ ] Verify masih "test" mode (allow all)
- [ ] Click "Publish" jika ada changes

### Kontak Tidak Simpan
- [ ] Check console errors (LogCat for Android)
- [ ] Check Firestore quota (free: 50k reads/day)
- [ ] Verify network connection
- [ ] Try refresh app

## Post-Setup
- [ ] 📱 Test di multiple devices
- [ ] 🔐 Plan authentication strategy (future)
- [ ] 📊 Monitor Firestore usage
- [ ] 🚀 Plan production security rules

---

**Status**: Ready for Setup ✅
**Last Updated**: Nov 26, 2025

📝 **Note**: Setiap step penting! Jangan skip.

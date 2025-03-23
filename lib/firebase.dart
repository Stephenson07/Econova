import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart'; // for platform check

class FirebaseService {
  static Future<void> initializeFirebase() async {
    try {
      // Determine Firebase options based on the platform
      FirebaseOptions firebaseOptions = _getFirebaseOptions();

      // Initialize Firebase with the correct options
      await Firebase.initializeApp(options: firebaseOptions);
    } catch (e) {
      // Handle any errors during Firebase initialization
      rethrow; // Re-throw the error for further handling, if necessary
    }
  }

  static FirebaseOptions _getFirebaseOptions() {
    if (kIsWeb) {
      // Return the web-specific Firebase options
      return DefaultFirebaseOptions.web;
    } else {
      // Return the platform-specific Firebase options
      return DefaultFirebaseOptions.currentPlatform;
    }
  }
}

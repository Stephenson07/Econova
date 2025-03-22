import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A provider class to handle user authentication state
///
/// This class maintains the current user and provides methods
/// to update the user state across the application.
class UserProviderAuth with ChangeNotifier {
  User? _user;

  // Getter for the current user
  User? get user => _user;

  // Check if user is signed in
  bool get isSignedIn => _user != null;

  // Set user and notify listeners
  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  // Clear user data on sign out
  void clearUser() {
    _user = null;
    notifyListeners();
  }

  // Get user display name or email
  String get userName {
    if (_user == null) return '';

    return _user!.displayName?.isNotEmpty == true
        ? _user!.displayName!
        : _user!.email ?? 'User';
  }

  // Get user email
  String? get userEmail => _user?.email;

  // Get user ID
  String? get userId => _user?.uid;

  // Get user photo URL
  String? get userPhotoUrl => _user?.photoURL;

  // Check if user email is verified
  bool get isEmailVerified => _user?.emailVerified ?? false;

  // Listen for auth state changes
  void initAuthStateListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setUser(user);
    });
  }
}

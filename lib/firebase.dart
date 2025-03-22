import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart'; // Important for web check

class FirebaseService {
  static Future<void> initializeFirebase() async {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.web, // Use web options for web platform
      );
    } else {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }
}


// To send data to the firebase
// final userData = {
//         'id': id,
//         'name': _nameController.text,
//         'email': _emailController.text,
//         'timestamp': DateTime.now().toIso8601String(),
//       };


//       // Send data to Firebase at path 'users/{id}'
//       await _database.child('users').child(id).set(userData);


//to fetch the data form the firebase
//  try {
//       // Get data from 'users' node
//       final snapshot = await _database.child('users').get();
      
//       if (snapshot.exists) {
//         final data = snapshot.value as Map<dynamic, dynamic>;
        
//         // Convert to List of Maps for easier handling in Flutter
//         final List<Map<String, dynamic>> userList = [];
//         data.forEach((key, value) {
//           final user = Map<String, dynamic>.from(value as Map);
//           userList.add(user);
//         });


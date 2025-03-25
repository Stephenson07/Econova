import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAcUcSq3htWTu3xvr7IcDKlJ-nGL2KoTKg',
    appId: '1:51679082687:android:b108845b8e513cf1c1ee0a',
    messagingSenderId: '51679082687',
    projectId: 'myproject-f8cca',
    databaseURL: 'https://myproject-f8cca-default-rtdb.firebaseio.com',
    storageBucket: 'myproject-f8cca.firebasestorage.app',
    authDomain: 'myproject-f8cca.firebaseapp.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAcUcSq3htWTu3xvr7IcDKlJ-nGL2KoTKg',
    appId: '1:51679082687:android:b108845b8e513cf1c1ee0a',
    messagingSenderId: '51679082687',
    projectId: 'myproject-f8cca',
    databaseURL: 'https://myproject-f8cca-default-rtdb.firebaseio.com',
    storageBucket: 'myproject-f8cca.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC53WGg4kn9CQcLQhBhIvaXllx4uow11OQ',
    appId: '1:51679082687:ios:2adc41b87e3f2964c1ee0a',
    messagingSenderId: '51679082687',
    projectId: 'myproject-f8cca',
    databaseURL: 'https://myproject-f8cca-default-rtdb.firebaseio.com',
    storageBucket: 'myproject-f8cca.firebasestorage.app',
    iosBundleId: 'com.example.testProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC53WGg4kn9CQcLQhBhIvaXllx4uow11OQ',
    appId: '1:51679082687:ios:2adc41b87e3f2964c1ee0a',
    messagingSenderId: '51679082687',
    projectId: 'myproject-f8cca',
    databaseURL: 'https://myproject-f8cca-default-rtdb.firebaseio.com',
    storageBucket: 'myproject-f8cca.firebasestorage.app',
    iosBundleId: 'com.example.testProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC6jO93WuwbCZDwK05xMGnZRaI_2dnKVeU',
    appId: '1:51679082687:web:1d6a63a8d478873fc1ee0a',
    messagingSenderId: '51679082687',
    projectId: 'myproject-f8cca',
    authDomain: 'myproject-f8cca.firebaseapp.com',
    databaseURL: 'https://myproject-f8cca-default-rtdb.firebaseio.com',
    storageBucket: 'myproject-f8cca.firebasestorage.app',
    measurementId: 'G-P8EG9ZZP6H',
  );
}

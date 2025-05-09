// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyDRXrBQbUrlezSayCmyRd0DCbUxvEYnHnw',
    appId: '1:811720176305:web:2acd57731f2fabb6786890',
    messagingSenderId: '811720176305',
    projectId: 'login-5721',
    authDomain: 'login-5721.firebaseapp.com',
    storageBucket: 'login-5721.firebasestorage.app',
    measurementId: 'G-QMS3DCPNJ8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCqkiKJGqh2Ne3qf-elgBCDf1H_g5zbMAU',
    appId: '1:811720176305:android:29070201a816e0df786890',
    messagingSenderId: '811720176305',
    projectId: 'login-5721',
    storageBucket: 'login-5721.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC3h03HAmsBcOMGLIENNGpa6f_oFMOWH7o',
    appId: '1:811720176305:ios:e9cc592dfa2e43fa786890',
    messagingSenderId: '811720176305',
    projectId: 'login-5721',
    storageBucket: 'login-5721.firebasestorage.app',
    iosBundleId: 'com.example.sampleLogin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC3h03HAmsBcOMGLIENNGpa6f_oFMOWH7o',
    appId: '1:811720176305:ios:e9cc592dfa2e43fa786890',
    messagingSenderId: '811720176305',
    projectId: 'login-5721',
    storageBucket: 'login-5721.firebasestorage.app',
    iosBundleId: 'com.example.sampleLogin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDRXrBQbUrlezSayCmyRd0DCbUxvEYnHnw',
    appId: '1:811720176305:web:953fde04247e7d79786890',
    messagingSenderId: '811720176305',
    projectId: 'login-5721',
    authDomain: 'login-5721.firebaseapp.com',
    storageBucket: 'login-5721.firebasestorage.app',
    measurementId: 'G-KKH2P60J03',
  );
}

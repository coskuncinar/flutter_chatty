// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDs8CuF4RUpDtcvPsvxx1XC4VeN6yjJio8',
    appId: '1:356482546023:web:7660c96ecee6482fc4d7c2',
    messagingSenderId: '356482546023',
    projectId: 'flutterchatty-database',
    authDomain: 'flutterchatty-database.firebaseapp.com',
    storageBucket: 'flutterchatty-database.appspot.com',
    measurementId: 'G-7EF2WJRBS5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIdpkRvEWA1lU4yJocxyKK8xe7BdJ01Jc',
    appId: '1:356482546023:android:19630c7e0e7dbefec4d7c2',
    messagingSenderId: '356482546023',
    projectId: 'flutterchatty-database',
    storageBucket: 'flutterchatty-database.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJ-LsTFGKD-H6KQWh-dsw1kxKA_Zv8x28',
    appId: '1:356482546023:ios:2d418df07a6c9bf1c4d7c2',
    messagingSenderId: '356482546023',
    projectId: 'flutterchatty-database',
    storageBucket: 'flutterchatty-database.appspot.com',
    androidClientId: '356482546023-21874fen44one5vn2648s1lntfurr447.apps.googleusercontent.com',
    iosClientId: '356482546023-756ko1e0oq6btijsuk0rda74ac3o37oo.apps.googleusercontent.com',
    iosBundleId: 'com.coskuncinar.fchatty',
  );
}

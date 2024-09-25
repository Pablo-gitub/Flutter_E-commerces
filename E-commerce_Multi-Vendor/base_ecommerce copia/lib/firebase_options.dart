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
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'your apikey web',
    appId: 'your appid web',
    messagingSenderId: 'your messagingSenderId',
    projectId: 'your projectId',
    authDomain: 'your authDomain',
    storageBucket: 'your storageBucket',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'your apikey android',
    appId: 'your appid android',
    messagingSenderId: 'your messagingSenderId',
    projectId: 'your projectId',
    storageBucket: 'your storageBucket',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'your apikey ios',
    appId: 'your appid ios',
    messagingSenderId: 'your messagingSenderId',
    projectId: 'your projectId',
    storageBucket: 'your storageBucket',
    iosClientId: 'your iosClientId',
    iosBundleId: 'your iosBundleId',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'your apikey ios',
    appId: 'your appid ios',
    messagingSenderId: 'your messagingSenderId',
    projectId: 'your projectId',
    storageBucket: 'your storageBucket',
    iosClientId: 'your iosClientId',
    iosBundleId: 'your iosBundleId.RunnerTests',
  );
}
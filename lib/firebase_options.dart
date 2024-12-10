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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCgtKP-rhJwn7G9BrAVPWYruba9hzRzikI',
    appId: '1:942027754707:web:4cf20f35d5b0b42d489826',
    messagingSenderId: '942027754707',
    projectId: 'flavory-26aac',
    authDomain: 'flavory-26aac.firebaseapp.com',
    storageBucket: 'flavory-26aac.firebasestorage.app',
    measurementId: 'G-Z6QJL2DDHW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA3EbzCQtYQUhDc8TxFrRKRmdLFDxtJlvc',
    appId: '1:942027754707:android:9666f9cfa883cfee489826',
    messagingSenderId: '942027754707',
    projectId: 'flavory-26aac',
    storageBucket: 'flavory-26aac.firebasestorage.app',
  );
}

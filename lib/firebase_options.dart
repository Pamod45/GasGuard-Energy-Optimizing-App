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
    apiKey: 'AIzaSyCGUtBak0Z8bnaIFTM6_B7zuINVe7T2gYM',
    appId: '1:545997508087:web:f6707676239ccc62ed32f2',
    messagingSenderId: '545997508087',
    projectId: 'gas-guard-fdd8a',
    authDomain: 'gas-guard-fdd8a.firebaseapp.com',
    storageBucket: 'gas-guard-fdd8a.firebasestorage.app',
    measurementId: 'G-Q848YMTHBL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6CM4mUUA37TtgN069Ou-TtRh9EvmyUAc',
    appId: '1:545997508087:android:2fb8415ea2a6fa56ed32f2',
    messagingSenderId: '545997508087',
    projectId: 'gas-guard-fdd8a',
    storageBucket: 'gas-guard-fdd8a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtwatwQ7ikZjG3KKbTRwbEW85ncrXbVqU',
    appId: '1:545997508087:ios:353ee39d0a3ea44eed32f2',
    messagingSenderId: '545997508087',
    projectId: 'gas-guard-fdd8a',
    storageBucket: 'gas-guard-fdd8a.firebasestorage.app',
    androidClientId: '545997508087-ndgq6ioeej2rpc40s0pci6mv2runnvre.apps.googleusercontent.com',
    iosClientId: '545997508087-e84g7087h8blhiai7r605ovsr786if21.apps.googleusercontent.com',
    iosBundleId: 'com.example.gasguardFinal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtwatwQ7ikZjG3KKbTRwbEW85ncrXbVqU',
    appId: '1:545997508087:ios:353ee39d0a3ea44eed32f2',
    messagingSenderId: '545997508087',
    projectId: 'gas-guard-fdd8a',
    storageBucket: 'gas-guard-fdd8a.firebasestorage.app',
    androidClientId: '545997508087-ndgq6ioeej2rpc40s0pci6mv2runnvre.apps.googleusercontent.com',
    iosClientId: '545997508087-e84g7087h8blhiai7r605ovsr786if21.apps.googleusercontent.com',
    iosBundleId: 'com.example.gasguardFinal',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCGUtBak0Z8bnaIFTM6_B7zuINVe7T2gYM',
    appId: '1:545997508087:web:3c23e4bd2c8f1c05ed32f2',
    messagingSenderId: '545997508087',
    projectId: 'gas-guard-fdd8a',
    authDomain: 'gas-guard-fdd8a.firebaseapp.com',
    storageBucket: 'gas-guard-fdd8a.firebasestorage.app',
    measurementId: 'G-1ZRPMKYXP3',
  );

}
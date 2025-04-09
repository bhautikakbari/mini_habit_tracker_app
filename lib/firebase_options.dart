import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // TODO: Configure Firebase for Web
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
            'you can create a web project in the Firebase console.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAO369B41FfT10eVwf9EmkuklJTW7wK5PI',
    appId: '1:475532993611:android:ca551d309dc871659899ce',
    messagingSenderId: '475532993611',
    projectId: 'mini-habit-app',
    storageBucket: 'mini-habit-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBtb2VpTUs5cEjZQiQ83txtFaEXX7Ycvrg',
    appId: '1:475532993611:ios:8a4630c71130ba799899ce',
    messagingSenderId: '475532993611',
    projectId: 'mini-habit-app',
    storageBucket: 'mini-habit-app.firebasestorage.app',
  );
}
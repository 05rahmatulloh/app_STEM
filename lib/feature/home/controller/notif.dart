import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class notifikasi {
  final message = FirebaseMessaging.instance;

  Future<void> _requestPermision() async {
    final notificationSettings = await FirebaseMessaging.instance
        .requestPermission(provisional: true);

    // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print("di izinkan");
    } else {
      print("tidak di izinkan");
    }

    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests..
    }
  }


  void _setupFCMListener()async{
    
  }
}

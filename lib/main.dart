// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lomba6/core/system.dart';
import 'package:lomba6/feature/History/controller/historyContoller.dart';
import 'package:lomba6/feature/auth/view/ceklogin.dart';
import 'package:lomba6/feature/auth/view/login.dart';
import 'package:lomba6/feature/home/controller/homepage.dart';
import 'package:lomba6/feature/home/controller/snakebar.dart';
import 'package:lomba6/feature/home/view/homepage.dart';
import 'package:lomba6/firebase_options.dart';
import 'package:lomba6/feature/chat/view/chat_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 🔹 Firebase dulu
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔹 Baru FCM
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  final notifkasi = NotifikasiServis();
  await notifkasi.initfcm();

  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

Future<void> onBackgroundMessage(RemoteMessage message) async {
  NotifikasiServis home = NotifikasiServis();

  print("message ${message.notification?.title}");
  home.tambahAyamMati("${message.notification?.title}", "Afkir");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      scaffoldMessengerKey: SnackbarService.messengerKey, // 👈 penting

      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot
        // reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Homepage(),
    );
  }
}

import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:lomba6/feature/History/controller/historyContoller.dart';
import 'package:lomba6/feature/History/view/history.dart';
import 'package:lomba6/feature/home/controller/homepage.dart';
import 'package:lomba6/feature/home/controller/snakebar.dart';

class NotifikasiServis extends GetxController {
  final _firebasemessenging = FirebaseMessaging.instance;
  HistoryController history = Get.put(HistoryController());
  HomepageController home = Get.put(HomepageController());

  initfcm() async {
    await _firebasemessenging.requestPermission();
    final fcmToken = await _firebasemessenging.getToken();
    print("fcm token:$fcmToken");

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("message ${message.notification?.title}");
            tambahAyamMati("${message.notification?.title}", "Afkir");

    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message ${message.notification?.title}");
      tambahAyamMati("${message.notification?.title}", "Afkir");
    });
  }

  Future<void> tambahAyamMati(String id, String alasan) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("idKandang")
        .child(id)
        .child("data")
        .child("Status");

    DatabaseReference ref2 = FirebaseDatabase.instance
        .ref()
        .child("idKandang")
        .child(id)
        .child("data")
        .child("Umur");

    DatabaseEvent event = await ref.once();
    DatabaseEvent event2 = await ref2.once();

    if (event.snapshot.exists) {
      String status = event.snapshot.value.toString();
      String umur = event2.snapshot.value.toString();

      print("Status ayam $id = $status");

      if (status == "Hidup") {
        await FirebaseDatabase.instance
            .ref()
            .child("idKandang")
            .child(id)
            .child("data")
            .update({
              "Status": "Mati",
              "TanggalKeluar": home.tanggalGlobal.value,
              "Alasan": alasan,
            });

        history.cetakHistory(id, "Mati", int.parse(umur), alasan);

        SnackbarService.show(
          "Berhasil Mengubah Menjadi NON Produktif",
          bg: const Color.fromARGB(255, 175, 76, 76),
          seconds: 2,
        );
      } else if (status == "Mati") {
        print("Mati");
        SnackbarService.show(
          "Kandang id $id sudah NON Produktif",
          bg: const Color.fromARGB(255, 175, 76, 76),
          seconds: 2,
        );
      }
    }
  }
}

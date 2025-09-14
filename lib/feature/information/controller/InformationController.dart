import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:lomba6/feature/home/controller/homepage.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';

class Informationcontroller extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit

    print(HomepageController().dataperkandangasli);
    super.onInit();
  }

  var Search = "".obs;
  var data = [].obs;

  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  Future<void> getKandangData() async {
    final snapshot = await dbRef.child("idKandang").get();

    if (snapshot.exists) {
      final rawData = Map<String, dynamic>.from(snapshot.value as Map);

      // Ubah ke List agar mudah ditampilkan
      final kandangList = rawData.entries.map((entry) {
        final kandangId = entry.key;
        final kandangDetail = Map<String, dynamic>.from(entry.value);

        return {
          "id": kandangId,
          "bulanan": kandangDetail["Bulanan"],
          "harian": kandangDetail["Harian"],
          "data": kandangDetail["data"],
        };
      }).toList();
      data.value = kandangList;
      // print("INI ADALAHHHHHHHH      INFORMASI KANDANG");
      // print(kandangList);
    }
  }
}

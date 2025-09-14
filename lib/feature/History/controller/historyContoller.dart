import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryController extends GetxController {
  var data = <String, dynamic>{}.obs;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("idKandang");

  @override
  void onInit() {
    super.onInit();
    listenData(); // realtime listener
  }

  /// Simpan history baru
  Future<void> cetakHistory(
    String id,
    String status,
    int umur,
    String? keterangan,
  ) async {
    DateTime now = DateTime.now();
    String formatted = DateFormat("yyyy-MM-dd HH:mm").format(now);

    final kandangRef = _dbRef.child("$id/data/History/$formatted");

    await kandangRef.set({
      "Status": status,
      "Keterangan": keterangan ?? "",
      "Umur": umur,
    });

    print("✅ berhasil simpan history: $formatted");
  }

  /// Realtime listener
  void listenData() {
    _dbRef.onValue.listen(
      (DatabaseEvent event) {
        if (event.snapshot.value != null) {
          data.clear();
          final map = Map<String, dynamic>.from(event.snapshot.value as Map);
          data.assignAll(map);
          print("📡 Data update: $data");
        } else {
          data.clear();
          print("⚠️ Tidak ada data di RTDB");
        }
      },
      onError: (e) {
        print("❌ Error listenData: $e");
      },
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart' as pw;
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lomba6/feature/History/controller/historyContoller.dart';
import 'package:lomba6/feature/home/controller/snakebar.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw hide CrossAxisAlignment;

class HomepageController extends GetxController {
  final HistoryController history = Get.put(HistoryController());

  var isSwitched = false.obs; // nilai awal switch

  var dateicon = false.obs;
  var download = false.obs;
  var totalHidup = 0.obs;
  var totalMati = 0.obs;
  var tambahAyamIcon = 3.obs;
  var bulanglobal = "".obs;
  var loadingIconTambahAyam = false.obs;

  var loadingIconTambahAyamMati = false.obs;
  var tanggalGlobal = "".obs;
  var totalTelur = 0.obs;
  var dataperkandangasli = [].obs;
  var dataAyamA = [].obs;
  var dataAyamB = [].obs;
  //  var _selectedItem.obs;
  var kandangnya = "A".obs;
  var selectedItem = RxnString(); // bisa null

  var idAyamMatiText = "".obs; // 🟢 untuk reactive textfield

  var SelectedAlasan =
      "".obs; // ubah jadi string kosong default, bukan RxnString
  final List<String> keterangan = ['Sakit', 'Afkir', 'Mati'];

  // Validasi form
  bool get isFormValid =>
      idAyamMatiText.value.isNotEmpty && SelectedAlasan.value.isNotEmpty;

  // 2. Daftar item dengan data yang lebih kompleks (jika diperlukan)
  final List<String> kandangItems = ['A', 'B'];
  final databaseRef = FirebaseDatabase.instance.ref();
  StreamSubscription? _datakandangSubscription;

  @override
  void onInit() {
    super.onInit();
    // Panggil listener untuk data perkandang saat pertama kali controller diinisialisasi
    listendataperkandang();
    listenJumlahHidup();
    listenJumlahMati();
  }

  @override
  void onClose() {
    // Pastikan untuk mematikan listener saat controller tidak lagi digunakan
    _datakandangSubscription?.cancel();
    super.onClose();
  }

  // Metode ini dipanggil dari widget saFtambahat tanggal dipilih
  void onDateSelected(DateTime value) {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(value);

    // Perbarui tanggal global
    tanggalGlobal.value = formattedDate;

    // Hitung ulang total telur berdasarkan tanggal baru
    calculateTotalTelur(formattedDate);

    // Sembunyikan date picker
    dateicon.value = !dateicon.value;
  }

  // Metode untuk menghitung total telur berdasarkan tanggal
  void calculateTotalTelur(String tanggal) {
    totalTelur.value = 0;
    // Gunakan data yang sudah ada di dataperkandangasli
    for (var dataItem in dataperkandangasli) {
      final dataHarian = dataItem['data']['Harian'];
      final dataTelurHarian = dataHarian[tanggal];

      final int jumlahTelur = dataTelurHarian != null
          ? dataTelurHarian['jumlahTelurPerhari'] as int
          : 0;

      if (jumlahTelur > 0) {
        totalTelur.value += jumlahTelur;
      }
    }
  }

  // Metode untuk mendengarkan perubahan pada data perkandang
  void listendataperkandang() {
    _datakandangSubscription = databaseRef.child('idKandang').onValue.listen((
      event,
    ) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        dataperkandangasli.clear();
        data.forEach((key, value) {
          dataperkandangasli.add({'idKandang': key, 'data': value});
        });

        dataAyamA.clear();
        dataAyamB.clear();
        for (var item in dataperkandangasli) {
          String idKandang = item['idKandang'];
          if (idKandang.startsWith('A')) {
            dataAyamA.add(item);
          } else if (idKandang.startsWith('B')) {
            dataAyamB.add(item);
          }
        }

        if (tanggalGlobal.value.isEmpty) {
          final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
          tanggalGlobal.value = today;
          final bulan = DateFormat('yyyy-MM').format(DateTime.now());
          bulanglobal.value = bulan;
          calculateTotalTelur(today);
        } else {
          calculateTotalTelur(tanggalGlobal.value);
        }
      }
    });
  }

  

  void printStatusById(String id, int umur) {
    loadingIconTambahAyam.value = true;

    // Future.delayed(Duration(seconds: 5));
    final kandang = dataperkandangasli.firstWhere(
      (item) => item["idKandang"] == id,
      orElse: () => null,
    );

    if (kandang != null && kandang["data"]?["data"]?["Status"] != null) {
      print(
        "Status ${kandang["idKandang"]}: ${kandang["data"]["data"]["Status"]}",
      );

      if (kandang["data"]["data"]["Status"] == "Hidup") {
        print("ayam masih hidup");
        SnackbarService.show(
          "Ayam Masih Produktif",
          bg: Colors.green,
          seconds: 2,
        );
      } else {
        tambahAyam(id, umur);
      }
    } else {
      print(kandang);
      print("Status untuk $id tidak ditemukan");
      SnackbarService.show(
        "ID Kandang $id tidak ditemukan",
        bg: const Color.fromARGB(255, 175, 76, 76),
        seconds: 2,
      );
    }
    loadingIconTambahAyam.value = false;
  }

  Future<void> tambahAyam(String id, int umur) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("idKandang")
        .child(id)
        .child("data")
        .child("Status");

    DatabaseEvent event = await ref.once();

    if (event.snapshot.exists) {
      String status = event.snapshot.value.toString();
      // print("Status ayam $id = $status");

      if (status == "Hidup") {
        print(status);
      } else if (status == "Mati") {
        await FirebaseDatabase.instance
            .ref()
            .child("idKandang")
            .child(id)
            .child("data")
            .update({
            "Alasan":"-",
              "Status": "Hidup",
              "Umur": umur,
              "TanggalMasuk": tanggalGlobal.value,
            });

        history.cetakHistory(id, "Hidup", umur, "");

        SnackbarService.show(
          "ID Kandang $id Sudah di tambahkan menjadi Produktif",
          bg: Colors.green,
          seconds: 3,
        );
      }
    }
  }

  void listenJumlahHidup() {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("idKandang");

    ref.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> kandang = event.snapshot.value as Map;
        int jumlah = 0;

        kandang.forEach((key, value) {
          if (value is Map && value['data'] != null) {
            if (value['data']['Status'] == "Hidup") {
              jumlah++;
            }
          }
        });

        totalHidup.value = jumlah;
        print(totalHidup);
        // langsung update RxInt
      } else {
        totalHidup.value = 0;
      }
    });
  }

  Future<void> tambahAyamMati(String id, String tanggal, String? alasan) async {
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
              "TanggalKeluar": tanggalGlobal.value,
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

  void listenJumlahMati() {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("idKandang");

    ref.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> kandang = event.snapshot.value as Map;
        int jumlah = 0;

        kandang.forEach((key, value) {
          if (value is Map && value['data'] != null) {
            if (value['data']['Status'] == "Mati") {
              jumlah++;
            }
          }
        });

        totalMati.value = jumlah;
        print(totalMati);
        // langsung update RxInt
      } else {
        totalMati.value = 0;
      }
    });
  }
}

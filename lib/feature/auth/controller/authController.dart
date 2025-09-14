import 'dart:convert';

// import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lomba6/core/api.dart';
// import 'package:lomba6/core/loadingPage.dart';
import 'package:lomba6/feature/auth/view/login.dart';
import 'package:lomba6/feature/home/view/Pegawai.dart';
import 'package:lomba6/feature/home/view/homepage.dart';
// import 'package:lomba6/features/auth/view/login.dart';
// import 'package:lomba3/features/home/view/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  api urlApi = api();
  var nama = "".obs;
  var password = "".obs;
  var loadLogout = false.obs;
  var loading = false.obs;
  Rx<String> token = "".obs;
  // var pesan = "".obs;
  Future<void> login(String namaController, String passwordController) async {
    loading.value = true;
    print(urlApi.url);

    final url = 'http://${urlApi.url}/LOMBA_DEPLOY/public/api/login';

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': namaController,
          'password': passwordController,
        }),
      ).timeout(Duration(seconds: 60));

      if (response.statusCode == 200) {
        // Login berhasil, tangani respons positif
        var hasil = jsonDecode(response.body);

        String tokenn = hasil["token"];
        simpanToken(tokenn, namaController);
        // token = tokenn;

        // String nama = hasil["nama"];
        print(hasil);
        if (response.statusCode == 200) {
          // Jika permintaan berhasil, uraikan JSON
          var hasil = jsonDecode(response.body);
          print("berhasil");
          print(hasil);

          if (hasil["nama"] == "Owner") {
            print("Owner berhaisl masuk");
            Get.offAll(Homepage());
          } else {
            print("Bukan owner");
            Get.offAll(PegawaiPage());
          }
          // Get.offAll(Homepage());
        } else {
          // Jika server mengembalikan error, lempar exceptio
          Get.offAll(LoginPage());
        }

        // Get.to(Homepage());
      } else {
        // Jika status code bukan 200, berarti ada kesalahan
        var errorData = jsonDecode(response.body);
        String errorMessage =
            errorData['message'] ?? "Terjadi kesalahan yang tidak diketahui.";
        print(
          'Login gagal. Status Code: ${response.statusCode}, Pesan: $errorMessage',
        );
        Get.snackbar('Gagal Login', errorMessage);
      }
    } catch (e) {
      // Tangani kesalahan jaringan atau parsing
      print('Terjadi kesalahan: $e');
      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server. Periksa koneksi Anda.',
      );
    } finally {
      // Pastikan loading selalu false, baik berhasil maupun gagal
      loading.value = false;
    }
  }

  Future<void> simpanToken(String tokenasli, String nama) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.setString("token", tokenasli);
    prefs.remove("nama");
    prefs.setString("nama", nama);
  }

  Future<void> cektoken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Get.to(LoadingPage());

      // isLoading.value = true;
      final url = 'http://${urlApi.url}/LOMBA_DEPLOY/public/api/user';
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              // Kirim token di header Authorization
              'Authorization': 'Bearer ${prefs.get("token")}',
            },
          )
          .timeout(Duration(seconds: 60));

      if (response.statusCode == 200) {
        // Jika permintaan berhasil, uraikan JSON
        var hasil = jsonDecode(response.body);
        print("berhasil");
        print(hasil);

        if (hasil["name"] == "Owner") {
          print("Owner berhaisl masuk");
          Get.offAll(Homepage());
        } else {
          print("Bukan owner");
          Get.offAll(PegawaiPage());
        }
        // Get.offAll(Homepage());
      } else {
        // Jika server mengembalikan error, lempar exceptio
        Get.offAll(LoginPage());
      }
    } catch (e) {
      print(e.toString());
      Get.offAll(LoginPage());
    } finally {
      // Pastikan status loading kembali false
      loading.value = false;
    }
  }

  Future<void> logout() async {
    loadLogout.value = true;

    // Homepage loading = Get.put(Homepage());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("coba");
    try {
      var url = Uri.parse(
        "http://${urlApi.url}/LOMBA_DEPLOY/public/api/logout",
      );

      var response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json", // penting kalau kirim JSON
            },
            body: jsonEncode({'name': prefs.getString('nama')}),
          )
          .timeout(Duration(seconds: 60));

      if (response.statusCode == 200) {
        prefs.remove('token');
        print("berhasil");

        loading.value = false;
       
        cektoken(); loadLogout.value = false;
      } else {
        print("gagal");
        loading.value = false;
      }
    } catch (e) {
      print("gagal logout ");
      loading.value = false;
    }
  }
}

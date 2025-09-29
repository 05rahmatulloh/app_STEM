import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lomba6/core/api.dart';
import 'package:lomba6/feature/chat/models/chat_model.dart';
import 'package:lomba6/feature/home/controller/homepage.dart';
// import 'package:app_STEM/core/api.dart';

/// ============ Komentar ============
/// [@ghozi] Kebingungan dalam penggunaan data yang akan di kirim ke API.

class ChatController extends GetxController {
  // static ChatController get to => Get.find(); // Ini harus menggunakan binding terlebih dahulu.

  Rx<String> prompt = "".obs;
  Rx<String> topic = "".obs; // Masih Bersifat Opsional
  Rx<int> idSession = 0.obs;
  RxList<ChatModel> chat = <ChatModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isTyping = false.obs;
  final HomepageController home = Get.put(HomepageController());
  late var dataaa;

  @override
  void onInit() {
    super.onInit();
    dataaa = home.dataperkandangasli;
    print("Data dari Homepage: $dataaa");
  }

  final String urlApiChat = api().baseApiChat;

  /// Methode untuk mengirim pesan dan data ke API.
  /// Dari API akan dikirim ke server LLM.
  /// Masih Kebingungan dalam penggunaan return apakah perlu menggunakan return
  /// atau langsung dimasuka atau mengubah bagian variabel chat.

  Future<Map<String, dynamic>> sendMessage() async {
    if (prompt.value.trim().isEmpty) {
      return {
        "error": true,
        "message": "Pesan tidak boleh kosong",
        "data": null,
      };
    }

    // Set loading state
    isLoading.value = true;
    isTyping.value = true;

    // Tambahkan pesan user ke chat
    chat.add(
      ChatModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: prompt.value,
        role: "user",
      ),
    );

    final uri = Uri.parse(urlApiChat);
    try {
      final respone = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          "prompt": prompt.value,
          // "topic": topic.value,
          // "sessionId": idSession.value.toString(),
        },
      );

      // Stop typing indicator
      isTyping.value = false;

      if (respone.statusCode == 200) {
        /// [FIX] Parse JSON response dengan benar
        final responseData = json.decode(respone.body);

        // Buat ChatModel untuk response dari AI
        final data = ChatModel(
          id:
              responseData['id']?.toString() ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          message:
              responseData['message'] ??
              responseData['response'] ??
              "Maaf, tidak ada respon dari AI.",
          role: "assistant",
        );

        /// Data akan dimasukan kedalam list sebagai tempat penyimpanan.
        chat.add(data);

        // Clear prompt after successful send
        prompt.value = "";

        /// Pemberian informasi bahwa data berhasil di ambil.
        return {"error": false, "message": "Success", "data": data};
      } else {
        // Tambahkan pesan error ke chat
        final errorMessage = ChatModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message:
              "Maaf, terjadi kesalahan pada server (${respone.statusCode}). Silakan coba lagi.",
          role: "assistant",
        );
        chat.add(errorMessage);

        return {
          "error": true,
          "message": "Failed to load data from API",
          "data": null,
        };
      }
    } catch (e) {
      // Stop typing indicator
      isTyping.value = false;

      // Tambahkan pesan error ke chat
      final errorMessage = ChatModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: "Terjadi kesalahan koneksi. Periksa koneksi internet Anda.",
        role: "assistant",
      );
      chat.add(errorMessage);

      return {"error": true, "message": e.toString(), "data": null};
    } finally {
      // Reset loading state
      isLoading.value = false;
      isTyping.value = false;
    }
  }
}

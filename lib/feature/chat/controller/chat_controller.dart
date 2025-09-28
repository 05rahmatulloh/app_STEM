import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lomba6/core/api.dart';
import 'package:lomba6/feature/chat/models/chat_model.dart';
import 'package:lomba6/feature/chat/models/chat_model.dart';
// import 'package:app_STEM/core/api.dart';

/// ============ Komentar ============
/// [@ghozi] Kebingungan dalam penggunaan data yang akan di kirim ke API.

class ChatController extends GetxController {
  // static ChatController get to => Get.find(); // Ini harus menggunakan binding terlebih dahulu.

  Rx<String> prompt = "".obs;
  Rx<String> topic = "".obs; // Masih Bersifat Opsional
  Rx<int> idSession = 0.obs;
  Rx<ChatModel> chat = ChatModel(id: "", message: "").obs;

  final String urlApiChat = api().baseApiChat;

  /// Methode untuk mengirim pesan dan data ke API.
  /// Dari API akan dikirim ke server LLM.
  /// Masih Kebingungan dalam penggunaan return apakah perlu menggunakan return
  /// atau langsung dimasuka atau mengubah bagian variabel chat.

  Future<Map<String, dynamic>> sendMessage() async {
    final uri = Uri.parse(urlApiChat);
    try {
      final respone = await http.post(
        uri,
        body: {
          "prompt": prompt.value,
          // "topic": topic.value,
          "sessionId": idSession.value.toString(),
        },
      );

      if (respone.statusCode == 200) {
        /// [ERROR] Tipe data yang ada di bagian respone.body adalah String belum di cek lagi.
        /// Mengambil data json.
        final data = ChatModel.fromJson(respone.body);
        chat.value = data;

        /// Dibaigan resturn masih belum tau yang penting ada dulu buat menghilangkan warna merah.
        return {"error": false, "message": "Success", "data": data};
      } else {
        return {
          "error": true,
          "message": "Failed to load data from API",
          "data": null,
        };
      }
    } catch (e) {
      return {"error": true, "message": e.toString(), "data": null};
    }
  }
}

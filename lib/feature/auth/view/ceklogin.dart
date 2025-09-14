// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:lomba6/feature/auth/controller/authController.dart';
// import 'package:lomba3/features/auth/controller/authController.dart';

class CekToken extends StatefulWidget {
  const CekToken({super.key});

  @override
  State<CekToken> createState() => _CekTokenState();
}

class _CekTokenState extends State<CekToken> {
  AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: controller.cektoken().timeout(Duration(seconds: 30)), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
            // Tampilkan loading selama proses cek token
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Tampilkan pesan error jika ada
            return Center(child: Text('Terjadi kesalahan'));
          } else {
            // Tampilkan konten setelah loading selesai
            return Center(child: Text('Jaringan '));
          }
      },),
    );
  }
}

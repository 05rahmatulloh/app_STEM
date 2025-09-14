import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lomba6/core/color.dart';
import 'package:lomba6/core/widget.dart';
import 'package:lomba6/feature/History/controller/historyContoller.dart';
import 'package:lomba6/feature/History/view/detile.dart';
import 'package:lomba6/feature/History/view/history.dart';
import 'package:lomba6/feature/auth/controller/authController.dart';
import 'package:lomba6/feature/home/controller/homepage.dart';
import 'package:lomba6/core/appbar.dart';
import 'package:lomba6/feature/home/view/home.dart';
import 'package:lomba6/feature/home/view/widget/dataayam.dart';
import 'package:lomba6/feature/home/view/widget/tambahAyamHidupMati.dart';
import 'package:lomba6/feature/information/view/information.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final AuthController auth = Get.put(AuthController());
  final HomepageController home = Get.put(HomepageController());
  final HistoryController history = Get.put(HistoryController());
  final PageNav page = Get.put(PageNav());

  @override
  Widget build(BuildContext context) {
    var lebar = MediaQuery.of(context).size.width;
    var tinggi = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Bottombar(),
      body: Column(
        children: [
          /// appbar atas
          appbarr(context),
          SizedBox(height: 10),

          // ✅ Konten utama
          Expanded(
            child: Obx(() {
              if (page.s.value == 1) {
                // Dashboard → scroll bebas
                return Home(home: home, lebar: lebar, tinggi: tinggi);
              } else if (page.s.value == 2) {
                // History → list pakai Expanded aman
                return History(history: history,);
              } else {
                return Information();
              }
            }),
          ),
        ],
      ),
    );
  }
}

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:lomba6/core/color.dart';
import 'package:lomba6/core/widget.dart';
import 'package:lomba6/feature/History/view/history.dart';
import 'package:lomba6/feature/home/view/homepage.dart';

class PageNav extends GetxController {
  var s = 1.obs;
}

class Bottombar extends StatelessWidget {
  Bottombar({super.key});

  final PageNav page = Get.put(PageNav());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CurvedNavigationBar(
        backgroundColor: Colors.white,
        height: 55,
        // buttonBackgroundColor: Colors.white,
        index: page.s.value,
        color: colorApp().primery,
        animationDuration: const Duration(milliseconds: 50),
        items: const <Widget>[
          Icon(Icons.dataset, size: 30, color: Colors.white),
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.history, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
                          page.s.value = 0;

              // print(0);
              break;

            case 1:
                          page.s.value = 1;

              // Get.to(Homepage());

              break;
            case 2:
              page.s.value = 2;
              // Get.to(History());
              break;
            default:
          }
        },
      );
    });
  }
}

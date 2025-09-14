import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:lomba6/core/color.dart';
import 'package:lomba6/core/widget.dart';
import 'package:lomba6/feature/auth/controller/authController.dart';
import 'package:lomba6/feature/home/controller/homepage.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:lomba6/feature/information/view/widget/sercing.dart';

// import 'package:get/get_rx/get_rx.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
AuthController auth = Get.put(AuthController());

// Homepage lod= Get.put(Homepage());
HomepageController home = Get.put(HomepageController());
// AuthController auth = Get.put(AuthController());

PageNav page = Get.put(PageNav());
Container appbarr(BuildContext context) {
  return Container(
    child: Obx(() {
      return Container(
        height: page.s.value != 1 && page.s.value != 2
            ? MediaQueryData.fromView(View.of(context)).size.height * 0.25
            : MediaQueryData.fromView(View.of(context)).size.height * 0.19,
        decoration: BoxDecoration(
          // color: ColorApp.orange,
          image: DecorationImage(
            image: AssetImage('assets/images/gbrkandang.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 15),
                  Obx(() {
                    if (auth.loadLogout.value == true) {
                      return CircularProgressIndicator();
                    } else {
                      return TextButton(
                        onPressed: () {
                          auth.logout();
                        },
                        child: CircleAvatar(
                          backgroundColor: colorApp().primery,
                          radius: 30,
                          backgroundImage: AssetImage(
                            'assets/images/gbraym2.png',
                          ),
                        ),
                      );
                    }
                  }),
                  SizedBox(width: 5),
                  Text(
                    'EGGSPERT',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontFamily: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ).fontFamily,
                    ),
                  ),

                  Spacer(),

                  Obx(() {
                    if (page.s.value == 1) {
                      return IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          home.dateicon.value = !home.dateicon.value;
                        },
                      );
                    }

                    return SizedBox();
                  }),

                  SizedBox(width: 10),
                ],
              ),

              // SizedBox(height: 20),
              Obx(() {
                if (page.s.value == 0) {
                  return SearchWidget();
                }

                return SizedBox();
              }),

              // SearchWidget(),
            ],
          ),
        ),
      );
    }),
  );
}

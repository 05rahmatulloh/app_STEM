import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lomba6/core/color.dart';
import 'package:lomba6/feature/home/controller/homepage.dart';
import 'package:lomba6/feature/home/view/widget/dataayam.dart';
import 'package:lomba6/feature/home/view/widget/dropdandata.dart';
import 'package:lomba6/feature/home/view/widget/tambahAyamHidupMati.dart';

class Home extends StatelessWidget {
  Home({
    super.key,
    required this.home,
    required this.lebar,
    required this.tinggi,
  });

  final HomepageController home;
  final double lebar;
  final double tinggi;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() {
            return home.dateicon.value
                ? SizedBox(
                    width: 300,
                    height: 350,
                    child: DatePicker(
                      minDate: DateTime(2021, 1, 1),
                      maxDate: DateTime(2045, 12, 31),
                      onDateSelected: (value) {
                        home.onDateSelected(value);
                      },
                    ),
                  )
                : Container(
                    width: lebar * 0.9,
                    height: 286,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: colorApp().primery,
                    ),
                    child: tambahAyam(home: home, width: lebar, height: tinggi),
                  );
          }),
      
          // tombol switch
          Center(
            child: Container(
              // height: 50,
              width: 150,
              child: Obx(() {
                return TextButton(
                  onPressed: () {
                    home.isSwitched.value = !home.isSwitched.value;
                  },
                  child: Row(
                    children: [
                      Text(
                        "Data",
                        style: GoogleFonts.poppins(
                          color: home.isSwitched.value
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Fitur",
                        style: GoogleFonts.poppins(
                          color: home.isSwitched.value
                              ? Colors.black
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
      
          // dropdown
          Obx(() => home.isSwitched.value ? dropAndData(home: home) : SizedBox()),
      
          // bagian bawah fleksibel
          Obx(() {
            if (home.isSwitched.value) {
              if (home.dataperkandangasli.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return Container(
                
                height: 180,
                width: lebar*0.9,
                
                child: dataayam(home: home));
            } else {
              return Container(
                child: SingleChildScrollView(
                  child: Image.asset(
                    "assets/images/image.png",
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}

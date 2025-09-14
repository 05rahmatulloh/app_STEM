import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lomba6/core/color.dart';
import 'package:lomba6/feature/History/controller/historyContoller.dart';
import 'package:lomba6/feature/information/controller/InformationController.dart';
import 'package:lomba6/feature/information/view/detileInformation.dart';

// ignore: must_be_immutable
class Information extends StatelessWidget {
  Information({super.key});

  Informationcontroller information = Get.put(Informationcontroller());

  @override
  Widget build(BuildContext context) {
    information.getKandangData();
    return 
    
    
    
    Center(
      child: Obx(() {
        // print(information.data);
        // return SizedBox();

        if (information.Search.value == "") {
          // semua data -> List
          return ListView.builder(
            itemCount: information.data.length,
            itemBuilder: (context, index) {
              final item = information.data[index];
              final data = Map<String, dynamic>.from(item["data"]);

              return _buildCard(item, data);
            },
          );
        } else {
          // filter data sesuai ID -> Grid
          final filtered = information.data
              .where(
                (item) => item["id"].toString() == information.Search.value,
              )
              .toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // jumlah kolom grid
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 3 / 2, // lebar : tinggi card
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final item = filtered[index];
              final data = Map<String, dynamic>.from(item["data"]);

              return _buildCard(item, data);
            },
          );
        }

      }),
    );
  }
}



Widget _buildCard(Map item, Map<String, dynamic> data) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
    color: colorApp().second,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            "ID Kandang: ${item["id"]}",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("Status: ${data["Status"]}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, bottom: 5),
                  child: Text("Umur: ${data["Umur"]}"),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Get.to(Detileinformation(id: item["id"],  ));
              },
              icon: const Icon(
                Icons.arrow_circle_right_sharp,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lomba6/core/color.dart';
import 'package:lomba6/feature/information/controller/InformationController.dart';

class Detileinformation extends StatelessWidget {
  final String id;

  const Detileinformation({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final Informationcontroller infoController = Get.find();

    // cari kandang berdasarkan id
    final kandang = infoController.data.firstWhereOrNull((e) => e["id"] == id);
    final harian = kandang?["harian"] ?? {};
    final harianList = (harian as Map).entries.toList();

    return Scaffold(
      appBar: AppBar(title: Text("Detail Kandang $id")),
      body: harianList.isEmpty
          ? const Center(child: Text("Belum ada data harian"))
          : ListView.builder(
              itemCount: harianList.length,
              itemBuilder: (context, index) {
                final entry = harianList[index];
                final tanggal = entry.key;
                final jumlahTelur = entry.value["jumlahTelurPerhari"];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.date_range, color: Colors.blue),
                    title: Text("Tanggal: $tanggal"),
                    subtitle: Text("Jumlah Telur: $jumlahTelur"),
                  ),
                );
              },
            ),
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
                Get.to(Detileinformation(id: item["id"]));
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

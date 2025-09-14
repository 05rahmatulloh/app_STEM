import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ini penting biar bisa pakai Obx dan RxString
import 'package:google_fonts/google_fonts.dart';
import 'package:lomba6/core/color.dart';
import 'package:lomba6/feature/home/controller/download.dart';
import 'package:lomba6/feature/home/controller/homepage.dart';

class tambahAyam extends StatelessWidget {
  tambahAyam({
    super.key,
    required this.home,
    required this.width,
    required this.height,
  });

  final HomepageController home;
  final LaporanAyamPage tes = LaporanAyamPage();

  final double width;
  final double height;

  // Pakai RxString agar reactive
  final RxString idAyamMatiRx = "".obs;

  final TextEditingController umurController = TextEditingController();
  final TextEditingController idKandangController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (home.tambahAyamIcon.value == 1) {
        // FORM NON PRODUKTIF
        return Container(
          width: width * 0.65,
          height: 260,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      home.tambahAyamIcon.value = 3;
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    "Tambah NON Produktif",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

       // TextField untuk ID kandang
              TextField(
                onChanged: (value) {
                  home.idAyamMatiText.value =
                      value; // 🟢 update reactive variable
                },
                decoration: InputDecoration(
                  labelText: "ID kandang",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),

              const SizedBox(height: 15),

              // Dropdown
              DropdownButtonFormField<String>(
                value: home.SelectedAlasan.value.isEmpty
                    ? null
                    : home.SelectedAlasan.value,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Keterangan',
                  labelStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.zero,
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
                iconSize: 30,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    home.SelectedAlasan.value = newValue;
                  }
                },
                items: home.keterangan.map<DropdownMenuItem<String>>((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 15),

              // Tombol Tambahkan
              Obx(() {
                final isValid = home.isFormValid;

                return SizedBox(
                  width: 50,
                  child: ElevatedButton(
                    onPressed: isValid
                        ? () async {
                            await home.tambahAyamMati(
                              home.idAyamMatiText.value,
                              home.tanggalGlobal.value,
                              home.SelectedAlasan.value,
                            );

                            // reset setelah submit
                            home.idAyamMatiText.value = "";
                            home.SelectedAlasan.value = "";
                            home.tambahAyamIcon.value = 3;
                          }
                        : null, // disable kalau belum valid
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isValid ? Colors.red : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                    ),
                    child: home.loadingIconTambahAyamMati == false
                        ? Text(
                            "Tambahkan",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )
                        : const CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }),
     ],
          ),
        );
      } else if (home.tambahAyamIcon.value == 2) {
        // FORM PRODUKTIF
        return Container(
          width: width * 0.65,
          height: 230,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      home.tambahAyamIcon.value = 3;
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    "Tambah Produktif",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Umur Ayam
              TextField(
                controller: umurController,
                decoration: InputDecoration(
                  hintText: "Hari",
                  labelText: "Umur Ayam ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // ID Kandang
              TextField(
                controller: idKandangController,
                decoration: InputDecoration(
                  labelText: "ID kandang",
                  hintText: "ID",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),

              // Tombol Tambahkan
              Container(
                width: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final int umur = int.parse(umurController.text);
                    final String id = idKandangController.text;

                    home.printStatusById(id, umur);

                    umurController.clear();
                    idKandangController.clear();

                    home.tambahAyamIcon.value = 3;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                  ),
                  child: Obx(() {
                    if (home.loadingIconTambahAyam == false) {
                      return Text(
                        "Tambahkan",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
                ),
              ),
            ],
          ),
        );
      }

      // DASHBOARD (default)
      if (home.tambahAyamIcon.value == 3) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Kandang",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // PRODUKTIF
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 240, 240),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            "Produktif",
                            style: GoogleFonts.poppins(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Obx(() {
                            return Text(
                              "${home.totalHidup.value}",
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }),
                          Row(
                            children: [
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  home.tambahAyamIcon.value = 2;
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.green,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // NON PRODUKTIF
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 240, 240),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            "NON produktif",
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Obx(() {
                            return Text(
                              "${home.totalMati.value}",
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }),
                          Row(
                            children: [
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  home.tambahAyamIcon.value = 1;
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Total Telur
            Text(
              'Total telur ${home.tanggalGlobal.value.isEmpty ? "hari ini" : home.tanggalGlobal.value} :\n${home.totalTelur.value}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
            ),

            // Download PDF
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    tes.downloadPdf();
                  },
                  icon: home.download.value
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.download, color: Colors.black),
                ),
              ],
            ),
          ],
        );
      }

      return const SizedBox.shrink();
    });
  }
}

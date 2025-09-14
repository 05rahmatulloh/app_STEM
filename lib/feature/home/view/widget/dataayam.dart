import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lomba6/core/color.dart';
import 'package:lomba6/feature/home/controller/homepage.dart';
import 'package:get/get.dart'; // Impor GetX

// class DataAyam extends StatelessWidget {
//   DataAyam({super.key, required this.tinggi, required this.lebar});

//   final double tinggi;
//   final double lebar;

//   // Menggunakan Get.find() untuk mendapatkan instance controller yang sudah ada
//   final HomepageController ctrl = Get.find<HomepageController>();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // Tampilkan loading indicator jika data masih kosong
//       if (ctrl.dataperkandangasli.isEmpty) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       return Column(
//         children: [
//           Container(
//             height: tinggi * 0.4,
//             width: lebar * 0.9,
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.all(Radius.circular(10)),
//               border: Border.all(color: const Color.fromARGB(0, 0, 0, 0)),
//             ),
//             child: GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//               ),
//               // Menggunakan .length untuk itemCount
//               itemCount: ctrl.dataperkandangasli.length,
//               itemBuilder: (context, index) {
//                 // Mengambil data spesifik untuk item saat ini
//                 final dataItem = ctrl.dataperkandangasli[index];
//                 final String idKandang = dataItem['idKandang'];
          
//                 // Akses data utama
//                 final data = dataItem["data"];
          
//                 // Akses data harian
//                 final dataHarian = data['Harian'];
          
//                 // Cek apakah data untuk tanggal 2025-08-12 ada
//                 // print(dataHarian);
//                 // print(ctrl.tanggalGlobal.value);
//                 final dataTelurHarian = dataHarian[ctrl.tanggalGlobal.value];
          
//                 // Ambil nilai 'jumlahTelurPerhari' dengan pengecekan null
//                 final int jumlahtelur = dataTelurHarian != null
//                     ? dataTelurHarian['jumlahTelurPerhari']
//                           as int // Gunakan 'as int' jika yakin tipenya
//                     : 0;
          
//                 print(jumlahtelur);
//                 // Mengakses data harian dari struktur nested Map
//                 // final dataHarian = dataItem['data']['Harian'];
//                 // final dataHarianTerbaru = dataHarian[dataHarian.keys.last] ?? {};
//                 // final int jumlahTelur =
//                 //     dataHarianTerbaru['2025-08-12'] ?? 0;
//                 // print(ctrl.tanggal.value);
//                 // print(dataTelurHarian);
//                 return Card(
//                   color: colorApp().primery,
//                   child: Center(
//                     child: Text(
//                       // Menggunakan data dinamis dari item
//                       '$idKandang\n $jumlahtelur Telur',
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }




class dataayam extends StatelessWidget {
  const dataayam({super.key, required this.home});

  final HomepageController home;

  @override
  Widget build(BuildContext context) {
        var lebar = MediaQuery.of(context).size.width;
    var tinggi = MediaQuery.of(context).size.height; 

    return Expanded(
      child: Container(
        child: Obx(() {
          return Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: home.kandangnya.value == 'A'
                  ? home.dataAyamA.length
                  : home.dataAyamB.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  if (home.kandangnya.value == "B") {
                    final dataItem = home.dataAyamB[index];
                    final String idKandang = dataItem['idKandang'];
                    final dataHarian = dataItem['data']['Harian'];
                    final dataTelurHarian = dataHarian[home.tanggalGlobal.value];
                    final int jumlahTelur = dataTelurHarian != null
                        ? dataTelurHarian['jumlahTelurPerhari'] as int
                        : 0;
            
                    return Card(
                      color: colorApp().primery,
                      child: Center(
                        child: Text(
                          '$idKandang\n$jumlahTelur Telur',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else {
                    final dataItem = home.dataAyamA[index];
                    final String idKandang = dataItem['idKandang'];
                    final dataHarian = dataItem['data']['Harian'];
                    final dataTelurHarian = dataHarian[home.tanggalGlobal.value];
                    final int jumlahTelur = dataTelurHarian != null
                        ? dataTelurHarian['jumlahTelurPerhari'] as int
                        : 0;
            
                    return Card(
                      color: colorApp().primery,
                      child: Center(
                        child: Text(
                          '$idKandang\n$jumlahTelur Telur',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                });
              },
            ),
          );
        }),
      ),
    );
  }
}

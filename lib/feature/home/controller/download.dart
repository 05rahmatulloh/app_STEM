import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

class LaporanAyamPage extends StatelessWidget {
  const LaporanAyamPage({super.key});

  Future<void> downloadPdf() async {
    try {
      // 1. Ambil data dari Firebase
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.get();

      if (!snapshot.exists) {
        print("Data tidak ditemukan");
        return;
      }

      final rawData = snapshot.value as Map;

      final idKandangData = rawData["idKandang"] as Map? ?? {};
      final kandangData = rawData["kandang"] as Map? ?? {};

      // 2. Buat dokumen PDF
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Text(
              "Laporan Data Ayam",
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),

            /// ========================
            /// BAGIAN 1 : Data idKandang
            /// ========================
            pw.Text(
              "Detail Kandang",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("ID"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("Status"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("Umur"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("Bulanan"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("Harian"),
                    ),
                  ],
                ),
                ...idKandangData.entries.map((entry) {
                  final id = entry.key;
                  final data = entry.value as Map;

                  final status = data["data"]?["Status"] ?? "-";
                  final umur = data["data"]?["Umur"]?.toString() ?? "-";

                  // Bulanan
                  String bulanan = "";
                  if (data["Bulanan"] != null) {
                    final bulanMap = data["Bulanan"] as Map;
                    bulanan = bulanMap.entries
                        .map((e) {
                          return "${e.key}: ${e.value["jumlahTelurPerbulan"]} telur";
                        })
                        .join("\n");
                  }

                  // Harian
                  String harian = "";
                  if (data["Harian"] != null) {
                    final hariMap = data["Harian"] as Map;
                    harian = hariMap.entries
                        .map((e) {
                          return "${e.key}: ${e.value["jumlahTelurPerhari"]} telur";
                        })
                        .join("\n");
                  }

                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(id),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(status),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(umur),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(bulanan),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(harian),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),

            pw.SizedBox(height: 20),

            /// ========================
            /// BAGIAN 1b : History tiap kandang
            /// ========================
            ...idKandangData.entries.map((entry) {
              final id = entry.key;
              final data = entry.value as Map;
              final history = data["data"]?["History"] as Map? ?? {};

              if (history.isEmpty) return pw.Container();

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 15),
                  pw.Text(
                    "Riwayat Kandang $id",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.grey200,
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text("Tanggal/Waktu"),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text("Status"),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text("Umur"),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text("Keterangan"),
                          ),
                        ],
                      ),
                      ...history.entries.map((h) {
                        final tgl = h.key;
                        final detail = h.value as Map;

                        final status = detail["Status"] ?? "-";
                        final umur = detail["Umur"]?.toString() ?? "-";
                        final ket = detail["Keterangan"] ?? "-";

                        return pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(tgl),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(status),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(umur),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(ket),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ],
              );
            }).toList(),

            pw.SizedBox(height: 30),

            /// ========================
            /// BAGIAN 2 : Data kandang (rekap)
            /// ========================
            pw.Text(
              "Rekap Kandang",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("ID"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("Status"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("Umur"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("Bulanan"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("Harian"),
                    ),
                  ],
                ),
                ...kandangData.entries.map((entry) {
                  final id = entry.key;
                  final data = entry.value as Map;

                  final status = data["Status"] ?? "-";
                  final umur = data["Umur"]?.toString() ?? "-";
                  final bulanan =
                      data["Bulanan"]?["jumlahTelurPerbulan"]?.toString() ??
                      "-";

                  String harian = "";
                  if (data["Harian"] != null) {
                    final hariMap = data["Harian"] as Map;
                    harian = hariMap.entries
                        .map((e) {
                          return "${e.key}: ${e.value["jumlahTelurPerhari"]} telur";
                        })
                        .join("\n");
                  }

                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(id),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(status),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(umur),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(bulanan),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(harian),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      );

      // 3. Simpan ke file
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/laporan_ayam.pdf");
      await file.writeAsBytes(await pdf.save());

      // 4. Buka PDF
      await OpenFile.open(file.path);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan Ayam")),
      body: Center(
        child: ElevatedButton(
          onPressed: downloadPdf,
          child: const Text("Download Laporan PDF"),
        ),
      ),
    );
  }
}

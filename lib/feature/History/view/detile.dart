import 'package:flutter/material.dart';
import 'package:lomba6/core/color.dart';

class Detile extends StatelessWidget {
  final Map data;
  final String id;
  const Detile({super.key, required this.data, required this.id});

  @override
  Widget build(BuildContext context) {
    String idnya = id;
    // Ambil History sebagai Map
    Map history = data["data"]['History'] ?? {};

    // Ubah jadi list agar bisa di-loop dengan ListView
    List<MapEntry> historyEntries = history.entries.toList();

    // Urutkan history berdasarkan tanggal (desc)
    historyEntries.sort((a, b) => b.key.compareTo(a.key));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,title:  Text("Detail History $idnya")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Alasan: ${data["data"]['Alasan'] ?? '-'}"),
            // Text("Status: ${data["data"]['Status'] ?? '-'}"),
            // Text("Tanggal Masuk: ${data["data"]['TanggalMasuk'] ?? '-'}"),
            // Text("Tanggal Keluar: ${data["data"]['TanggalKeluar'] ?? '-'}"),
            // Text("Umur: ${data["data"]['Umur'] ?? '-'}"),
            const SizedBox(height: 16),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Text(
                "Riwayat:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
        
            Expanded(
              child: ListView.builder(
                itemCount: historyEntries.length,
                itemBuilder: (context, index) {
                  final entry = historyEntries[index];
                  final date = entry.key; // misalnya "2025-09-04 12:22:29"
                  final detail = entry
                      .value; // Map {"Status": "...", "Keterangan": "...", "Umur": ...}
        
                  return Card(
                    color: colorApp().second,
                    margin: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    child: ListTile(
                      title: Text("Tanggal: $date"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Status: ${detail['Status'] ?? '-'}"),
                          Text("Keterangan: ${detail['Keterangan'] ?? '-'}"),
                          Text("Umur: ${detail['Umur'] ?? '-'}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

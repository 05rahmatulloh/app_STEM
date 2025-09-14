import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lomba6/core/color.dart';
import 'package:lomba6/feature/History/controller/historyContoller.dart';
import 'package:lomba6/feature/History/view/detile.dart';

class History extends StatelessWidget {
  const History({super.key, required this.history});

  final HistoryController history;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "History",
            style: GoogleFonts.poppins(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (history.data.isEmpty) {
                return const Center(child: Text("Belum ada data"));
              }

              return ListView.builder(
                itemCount: history.data.length,
                itemBuilder: (context, index) {
                  final entry = history.data.entries.elementAt(index);
                  final id = entry.key;
                  final detail = entry.value as Map;
                  // final data = detail["data"] ?? {};

                  return _buildCardHistory(id,detail);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// class card1 extends StatelessWidget {
//   const card1({
//     super.key,
//     required this.id,
//     required this.detail,
//   });

//   final String id;
//   final Map detail;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(
//         vertical: 3,
//         horizontal: 8,
//       ),
//       child: ListTile(
//         title: Text("ID: $id"),
//         // subtitle: Text("Detail: ${data.toString()}"),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 18),
//         onTap: () {
//           Get.to(Detile(data: detail, id: id));
//         },
//       ),
//     );
//   }
// }






Widget _buildCardHistory(String id, Map data) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
    color: colorApp().second,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            children: [
                 Text(
                "ID Kandang: $id",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                    Get.to(Detile(data: data, id: id));
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
        ),
      ],
    ),
  );
}

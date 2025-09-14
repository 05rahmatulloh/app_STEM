import 'package:flutter/material.dart';
import 'package:lomba6/feature/home/controller/homepage.dart';

class dropAndData extends StatelessWidget {
  const dropAndData({super.key, required this.home});

  final HomepageController home;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: home.selectedItem.value,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Pilih Kandang',
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
                  home.kandangnya.value = newValue ?? "A";
                },
                items: home.kandangItems.map<DropdownMenuItem<String>>((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text("Kandang $value"),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

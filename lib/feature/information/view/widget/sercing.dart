import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/utils.dart';
import 'package:lomba6/feature/information/controller/InformationController.dart';

class SearchWidget extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;

  const SearchWidget({super.key, this.hintText, this.onChanged});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();
  Informationcontroller informasi = Get.put(Informationcontroller());

  void _clear() {
    _controller.clear();
    informasi.Search.value = "";
    // widget.onChanged?.call('');
    // setState(() {}); // refresh tombol clear
  }

  @override
  Widget build(BuildContext context) {
    final Size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: Size.width * 0.8,
        height: 45,
        child: Material(
          elevation: 2,

          borderRadius: BorderRadius.circular(12),
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              informasi.Search.value = value;
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: widget.hintText ?? 'Search...',
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(icon: const Icon(Icons.close), onPressed: _clear)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }
}

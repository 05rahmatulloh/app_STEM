import 'package:flutter/material.dart';

class ViewChat extends StatelessWidget {
  const ViewChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/chat_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Row(children: [Icon(Icons.chat_bubble_rounded), Text('TULOOO')]),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_rounded),
            onPressed: () {
              print('List Chat History');
            },
          ),
        ],
      ),
      body: const Center(child: Text('This is the chat view.')),
    );
  }
}

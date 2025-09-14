import 'package:flutter/material.dart';

class SnackbarService {
  // Key global supaya bisa akses ScaffoldMessenger di mana saja
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Fungsi show snackbar
  static void show(String message, {Color bg = Colors.black, int seconds = 2}) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bg,
        duration: Duration(seconds: seconds),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

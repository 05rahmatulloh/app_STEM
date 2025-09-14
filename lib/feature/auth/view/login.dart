import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lomba6/core/color.dart';
import 'package:lomba6/feature/auth/controller/authController.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController controllernama = TextEditingController();
  final TextEditingController controllerpassword = TextEditingController();
  final AuthController controller = Get.put(AuthController());

  // Buat state untuk show/hide password
  final RxBool isPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    InputDecoration customInputDecoration({
      required String label,
      required String hint,
      required IconData icon,
      Widget? suffix,
    }) {
      return InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[700]),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: height * 0.1),
              Image.asset("assets/images/gbraym2.png", width: width * 0.4),
              Text(
                "EGGSPERT",
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Log in to get in the moment updates on the things that interest you",
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 180, 180, 180),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Username field
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controllernama,
                  decoration: customInputDecoration(
                    label: "Username",
                    hint: "Masukkan username kamu",
                    icon: Icons.person,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password field
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controllerpassword,
                    obscureText: !isPasswordVisible.value,
                    decoration: customInputDecoration(
                      label: "Password",
                      hint: "Masukkan password anda",
                      icon: Icons.lock,
                      suffix: IconButton(
                        icon: Icon(
                          isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey[700],
                        ),
                        onPressed: () {
                          isPasswordVisible.value = !isPasswordVisible.value;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.login(
                      controllernama.text,
                      controllerpassword.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorApp().primery,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.blue.withOpacity(0.3),
                  ),
                  child: Obx(
                    () => controller.loading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login", style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:absensi/utils/curdex.dart';

import 'package:absensi/utils/error_snacbarlogin.dart';

import 'package:absensi/utils/info_snacbarlogin.dart';
import 'package:absensi/utils/success_snacbar.dart';
import 'package:absensi/views/home/main_page_view.dart';
import 'package:absensi/views/login/new_password_view.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController with ChangeNotifier {
  static ValueNotifier<bool> isLoading = ValueNotifier(false);

  static TextEditingController emailC = TextEditingController();
  static TextEditingController passC = TextEditingController();

  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            if (passC.text == "password") {
              // Navigator.of(curdex.currentContext!)
              //     .pushNamedAndRemoveUntil('new-password', (route) => false);
              // Navigator.of(curdex.currentContext!).push(
              //     MaterialPageRoute(
              //       builder: (context) => const NewPasswordView(),
              //     ),
              Navigator.push(
                  curdex.currentContext!,
                  MaterialPageRoute(
                    builder: (context) => const NewPasswordView(),
                  ));

              infoSnackbarLogin(curdex.currentContext!, "Information",
                  "Password anda masih default, silahkan ganti password.");
            } else {
              Navigator.pushAndRemoveUntil(
                  curdex.currentContext!,
                  MaterialPageRoute(
                    builder: (context) => const MainPage(),
                  ),
                  (route) => false);
            }
          } else {
            showDialog(
              context: curdex.currentContext!,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Center(
                    child: Text("Anda belum verifikasi email"),
                  ),
                  content: const Text(
                    "Kamu belum verifikasi email, Lakukan verifikasi terlebih dahulu.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(curdex.currentContext!);
                      },
                      child: const Text("Batal"),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            await userCredential.user!.sendEmailVerification();
                            Navigator.pop(curdex.currentContext!);
                            successSnackbar(curdex.currentContext!, "Berhasil",
                                "Berhasil kirim verifikasi ke email anda");
                          } catch (e) {
                            errorSnacbarLogin(
                                curdex.currentContext!,
                                "Terjadi kesalahan",
                                "Tidak dapat mengirim email verifikasi, Silahkan Hubungi admin atau customer service.");
                          }
                        },
                        child: const Text("Kirim Verifikasi"))
                  ],
                );
              },
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          errorSnacbarLogin(curdex.currentContext!, "Terjadi kesalahan",
              "Tidak dapat mengirim email verifikasi, Silahkan Hubungi admin atau customer service.");
        } else if (e.code == 'wrong-password') {
          errorSnacbarLogin(curdex.currentContext!, "Terjadi kesalahan",
              "Password yang anda masukkan salah");
        }
      } catch (e) {
        errorSnacbarLogin(
            curdex.currentContext!, "Terjadi kesalahan", "Tidak dapat login.");
      } finally {
        isLoading.value = false;
      }
    } else {
      errorSnacbarLogin(curdex.currentContext!, "Terjadi kesalahan",
          "Email dan password wajib diisi.");
    }
  }
}

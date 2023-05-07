import 'package:absensi/utils/curdex.dart';

import 'package:absensi/utils/error_snacbarlogin.dart';

import 'package:absensi/utils/info_snacbarlogin.dart';

import 'package:absensi/utils/success_snacbar_login.dart';

import 'package:absensi/views/login/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class NewPasswordController with ChangeNotifier {
  static TextEditingController newPassC = TextEditingController();

  static FirebaseAuth auth = FirebaseAuth.instance;

  static void newPassword() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != "password") {
        try {
          String email = auth.currentUser!.email!;
          await auth.currentUser!.updatePassword(newPassC.text);
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
            email: email,
            password: newPassC.text,
          );

          Navigator.pushAndRemoveUntil(
              curdex.currentContext!,
              MaterialPageRoute(
                builder: (context) => const LoginView(),
              ),
              (route) => false);
          successSnackbarLogin(curdex.currentContext!, "Berhasil",
              "Berhasil mengganti password.");
        } on FirebaseAuthException catch (e) {
          if (e.code == "weak-password") {
            errorSnacbarLogin(curdex.currentContext!, "Terjadi kesalahan",
                "Password terlalu lemah, setidaknya 6");
          }
        } catch (e) {
          errorSnacbarLogin(curdex.currentContext!, "Terjadi kesalahan",
              "Tidak dapat membuat password baru. Hubungi admin atau Customer Service.");
        }
      } else {
        infoSnackbarLogin(curdex.currentContext!, "Information",
            "Password baru harus diubah");
      }
    } else {
      errorSnacbarLogin(
          curdex.currentContext!, "Information", "Password baru wajib diisi");
    }
  }
}

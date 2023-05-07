import 'package:absensi/utils/curdex.dart';

import 'package:absensi/utils/error_snacbarlogin.dart';

import 'package:absensi/utils/info_snacbarlogin.dart';
import 'package:absensi/utils/success_snacbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ForgotPasswordController with ChangeNotifier {
  static ValueNotifier<bool> isLoading = ValueNotifier(false);

  static TextEditingController emailC = TextEditingController();
  static FirebaseAuth auth = FirebaseAuth.instance;

  static void sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);

        Navigator.pop(curdex.currentContext!);
        successSnackbar(curdex.currentContext!, "Berhasil",
            "Berhasil mengirimkan email reset password");
      } catch (e) {
        errorSnacbarLogin(curdex.currentContext!, "Terjadi kesalahan",
            "Tidak dapat mengirim email reset password.");
      } finally {
        isLoading.value = false;
      }
    } else {
      infoSnackbarLogin(curdex.currentContext!, "Terjadi kesalahan",
          "Email tidak boleh kosong");
    }
  }
}
